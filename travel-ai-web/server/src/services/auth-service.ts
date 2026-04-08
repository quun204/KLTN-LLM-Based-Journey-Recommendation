import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import sql from "mssql";

import { getDbPool } from "../config/database.js";
import { env } from "../config/env.js";

export interface UserRow {
  nguoi_dung_id: number;
  ten_dang_nhap: string;
  email: string;
  mat_khau_bam: string;
  ho_ten: string;
  vai_tro: string;
  trang_thai: string;
}

export interface AuthUser {
  id: number;
  username: string;
  email: string;
  fullName: string;
  role: string;
}

export interface AuthResult {
  user: AuthUser;
  token: string;
}

interface RegisterPreferences {
  favoriteCategories?: string[];
  budgetPerTrip?: number | null;
  foodPreferences?: string;
  tripStyle?: string;
}

// Mock users chạy khi USE_MOCK_DATA=true
const mockUsers: UserRow[] = [
  {
    nguoi_dung_id: 1,
    ten_dang_nhap: "admin",
    email: "admin@dulichdb.vn",
    mat_khau_bam: bcrypt.hashSync("Admin@123", 10),
    ho_ten: "Quản trị viên",
    vai_tro: "admin",
    trang_thai: "active"
  }
];

export class AuthService {
  async register(data: {
    username: string;
    email: string;
    password: string;
    fullName: string;
    preferences?: RegisterPreferences;
  }): Promise<AuthResult> {
    const hashedPassword = await bcrypt.hash(data.password, 12);

    if (env.useMockData) {
      const existing = mockUsers.find(
        (u) => u.ten_dang_nhap === data.username || u.email === data.email
      );
      if (existing) {
        throw new Error("Tên đăng nhập hoặc email đã tồn tại.");
      }

      const newUser: UserRow = {
        nguoi_dung_id: mockUsers.length + 1,
        ten_dang_nhap: data.username,
        email: data.email,
        mat_khau_bam: hashedPassword,
        ho_ten: data.fullName,
        vai_tro: "user",
        trang_thai: "active"
      };
      mockUsers.push(newUser);
      return this.buildResult(newUser);
    }

    const pool = await getDbPool();
    const check = await pool
      .request()
      .input("username", sql.NVarChar(100), data.username)
      .input("email", sql.NVarChar(255), data.email).query(`
        SELECT 1 FROM dbo.NguoiDung
        WHERE [ten_dang_nhap] = @username OR [email] = @email
      `);

    if (check.recordset.length > 0) {
      throw new Error("Tên đăng nhập hoặc email đã tồn tại.");
    }

    const insert = await pool
      .request()
      .input("username", sql.NVarChar(100), data.username)
      .input("email", sql.NVarChar(255), data.email)
      .input("hash", sql.NVarChar(255), hashedPassword)
      .input("fullName", sql.NVarChar(255), data.fullName).query(`
        INSERT INTO dbo.NguoiDung
          ([ten_dang_nhap],[email],[mat_khau_bam],[ho_ten],[vai_tro],[trang_thai],[da_xac_thuc_email])
        OUTPUT INSERTED.*
        VALUES (@username, @email, @hash, @fullName, N'user', N'active', 0);
      `);

    const row = insert.recordset[0] as UserRow;

    // Tạo hồ sơ người dùng
    await pool
      .request()
      .input("userId", sql.Int, row.nguoi_dung_id)
      .query(
        `INSERT INTO dbo.HoSoNguoiDung ([nguoi_dung_id]) VALUES (@userId)`
      );

    await this.saveUserPreferences(row.nguoi_dung_id, data.preferences);

    return this.buildResult(row);
  }

  async login(data: {
    username: string;
    password: string;
  }): Promise<AuthResult> {
    const user = await this.findByUsername(data.username);

    if (!user) {
      throw new Error("Tên đăng nhập hoặc mật khẩu không đúng.");
    }

    if (user.trang_thai !== "active") {
      throw new Error("Tài khoản bị tạm khóa. Vui lòng liên hệ quản trị.");
    }

    const valid = await bcrypt.compare(data.password, user.mat_khau_bam);
    if (!valid) {
      throw new Error("Tên đăng nhập hoặc mật khẩu không đúng.");
    }

    if (!env.useMockData) {
      const pool = await getDbPool();
      await pool
        .request()
        .input("userId", sql.Int, user.nguoi_dung_id)
        .query(
          `UPDATE dbo.NguoiDung SET [dang_nhap_cuoi] = SYSUTCDATETIME() WHERE [nguoi_dung_id] = @userId`
        );
    }

    return this.buildResult(user);
  }

  async getUserById(id: number): Promise<AuthUser | null> {
    if (env.useMockData) {
      const u = mockUsers.find((m) => m.nguoi_dung_id === id);
      return u ? this.toAuthUser(u) : null;
    }

    const pool = await getDbPool();
    const result = await pool
      .request()
      .input("id", sql.Int, id).query<UserRow>(
        `SELECT [nguoi_dung_id],[ten_dang_nhap],[email],[mat_khau_bam],[ho_ten],[vai_tro],[trang_thai]
         FROM dbo.NguoiDung WHERE [nguoi_dung_id] = @id`
      );

    if (result.recordset.length === 0) return null;
    return this.toAuthUser(result.recordset[0]);
  }

  private async findByUsername(username: string): Promise<UserRow | null> {
    if (env.useMockData) {
      return (
        mockUsers.find(
          (u) => u.ten_dang_nhap === username || u.email === username
        ) ?? null
      );
    }

    const pool = await getDbPool();
    const result = await pool
      .request()
      .input("u", sql.NVarChar(255), username).query<UserRow>(`
        SELECT [nguoi_dung_id],[ten_dang_nhap],[email],[mat_khau_bam],[ho_ten],[vai_tro],[trang_thai]
        FROM dbo.NguoiDung
        WHERE [ten_dang_nhap] = @u OR [email] = @u
      `);

    return result.recordset[0] ?? null;
  }

  private buildResult(user: UserRow): AuthResult {
    const authUser = this.toAuthUser(user);
    const token = jwt.sign(
      { id: authUser.id, role: authUser.role },
      env.jwtSecret,
      { expiresIn: env.jwtExpiresIn } as jwt.SignOptions
    );
    return { user: authUser, token };
  }

  private async saveUserPreferences(userId: number, preferences?: RegisterPreferences): Promise<void> {
    if (!preferences) {
      return;
    }

    const pool = await getDbPool();

    const profileNotes = [
      preferences.foodPreferences ? `Do an ua thich: ${preferences.foodPreferences}` : null,
      preferences.tripStyle ? `Phong cach du lich: ${preferences.tripStyle}` : null
    ]
      .filter(Boolean)
      .join(" | ");

    if (profileNotes) {
      await pool
        .request()
        .input("userId", sql.Int, userId)
        .input("bio", sql.NVarChar(500), profileNotes)
        .query(`
          UPDATE dbo.HoSoNguoiDung
          SET [gioi_thieu] = @bio, [ngay_cap_nhat] = SYSUTCDATETIME()
          WHERE [nguoi_dung_id] = @userId;
        `);
    }

    if (typeof preferences.budgetPerTrip === "number" && Number.isFinite(preferences.budgetPerTrip) && preferences.budgetPerTrip > 0) {
      await pool
        .request()
        .input("userId", sql.Int, userId)
        .input("value", sql.NVarChar(255), String(Math.round(preferences.budgetPerTrip)))
        .input("score", sql.Int, 8)
        .query(`
          INSERT INTO dbo.SoThichNguoiDung ([nguoi_dung_id], [danh_muc_id], [loai_so_thich], [gia_tri_so_thich], [diem_uu_tien])
          VALUES (@userId, NULL, N'price_range', @value, @score);
        `);
    }

    if (preferences.foodPreferences && preferences.foodPreferences.trim()) {
      await pool
        .request()
        .input("userId", sql.Int, userId)
        .input("value", sql.NVarChar(255), preferences.foodPreferences.trim())
        .input("score", sql.Int, 7)
        .query(`
          INSERT INTO dbo.SoThichNguoiDung ([nguoi_dung_id], [danh_muc_id], [loai_so_thich], [gia_tri_so_thich], [diem_uu_tien])
          VALUES (@userId, NULL, N'favorite_service', @value, @score);
        `);
    }

    if (preferences.tripStyle && preferences.tripStyle.trim()) {
      await pool
        .request()
        .input("userId", sql.Int, userId)
        .input("value", sql.NVarChar(255), preferences.tripStyle.trim())
        .input("score", sql.Int, 6)
        .query(`
          INSERT INTO dbo.SoThichNguoiDung ([nguoi_dung_id], [danh_muc_id], [loai_so_thich], [gia_tri_so_thich], [diem_uu_tien])
          VALUES (@userId, NULL, N'trip_duration', @value, @score);
        `);
    }

    if (preferences.favoriteCategories && preferences.favoriteCategories.length > 0) {
      for (const code of preferences.favoriteCategories) {
        const categoryQuery = await pool
          .request()
          .input("code", sql.NVarChar(50), code)
          .query<{ danh_muc_id: number }>(`
            SELECT TOP 1 [danh_muc_id] FROM dbo.DanhMuc WHERE [ma_danh_muc] = @code;
          `);

        const categoryId = categoryQuery.recordset[0]?.danh_muc_id;
        if (!categoryId) {
          continue;
        }

        await pool
          .request()
          .input("userId", sql.Int, userId)
          .input("categoryId", sql.Int, categoryId)
          .input("value", sql.NVarChar(255), code)
          .input("score", sql.Int, 9)
          .query(`
            INSERT INTO dbo.SoThichNguoiDung ([nguoi_dung_id], [danh_muc_id], [loai_so_thich], [gia_tri_so_thich], [diem_uu_tien])
            VALUES (@userId, @categoryId, N'favorite_category', @value, @score);
          `);
      }
    }
  }

  private toAuthUser(row: UserRow): AuthUser {
    return {
      id: row.nguoi_dung_id,
      username: row.ten_dang_nhap,
      email: row.email,
      fullName: row.ho_ten,
      role: row.vai_tro
    };
  }
}

export const authService = new AuthService();
