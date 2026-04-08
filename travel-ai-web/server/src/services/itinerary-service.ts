import sql from "mssql";

import { getDbPool } from "../config/database.js";
import { env } from "../config/env.js";
import type { LocationRecord } from "../types/domain.js";
import { locationService } from "./location-service.js";

class ItineraryService {
  private readonly memoryPlans = new Map<number, number[]>();

  async listLocations(userId: number): Promise<LocationRecord[]> {
    if (env.useMockData) {
      return this.listFromMemory(userId);
    }

    try {
      return await this.listFromDb(userId);
    } catch {
      return this.listFromMemory(userId);
    }
  }

  async addLocation(userId: number, locationId: number): Promise<LocationRecord[]> {
    if (env.useMockData) {
      return this.addToMemory(userId, locationId);
    }

    try {
      return await this.addToDb(userId, locationId);
    } catch {
      return this.addToMemory(userId, locationId);
    }
  }

  async removeLocation(userId: number, locationId: number): Promise<LocationRecord[]> {
    if (env.useMockData) {
      return this.removeFromMemory(userId, locationId);
    }

    try {
      return await this.removeFromDb(userId, locationId);
    } catch {
      return this.removeFromMemory(userId, locationId);
    }
  }

  async getPreferredHotel(userId: number): Promise<LocationRecord | null> {
    const items = await this.listLocations(userId);
    return items.find((item) => item.categoryCode === "khach-san") ?? null;
  }

  private async addToMemory(userId: number, locationId: number): Promise<LocationRecord[]> {
    const current = this.memoryPlans.get(userId) ?? [];
    if (!current.includes(locationId)) {
      current.push(locationId);
      this.memoryPlans.set(userId, current);
    }

    return this.listFromMemory(userId);
  }

  private async removeFromMemory(userId: number, locationId: number): Promise<LocationRecord[]> {
    const current = this.memoryPlans.get(userId) ?? [];
    this.memoryPlans.set(
      userId,
      current.filter((id) => id !== locationId)
    );

    return this.listFromMemory(userId);
  }

  private async listFromMemory(userId: number): Promise<LocationRecord[]> {
    const ids = this.memoryPlans.get(userId) ?? [];
    const records = await Promise.all(ids.map((id) => locationService.getLocationById(id)));
    return records.filter((item): item is LocationRecord => item !== null);
  }

  private async addToDb(userId: number, locationId: number): Promise<LocationRecord[]> {
    const itineraryId = await this.getOrCreateItineraryId(userId);
    const pool = await getDbPool();
    const request = pool.request();
    request.input("itineraryId", sql.Int, itineraryId);
    request.input("locationId", sql.Int, locationId);

    await request.query(`
      IF NOT EXISTS (
        SELECT 1
        FROM dbo.ChiTietLichTrinh
        WHERE [lich_trinh_id] = @itineraryId AND [dia_diem_id] = @locationId
      )
      BEGIN
        DECLARE @nextOrder INT = ISNULL(
          (SELECT MAX([thu_tu_tham_quan]) + 1 FROM dbo.ChiTietLichTrinh WHERE [lich_trinh_id] = @itineraryId),
          1
        );

        INSERT INTO dbo.ChiTietLichTrinh ([lich_trinh_id], [dia_diem_id], [ngay_thu], [thu_tu_tham_quan])
        VALUES (@itineraryId, @locationId, 1, @nextOrder);
      END
    `);

    return this.listFromDb(userId);
  }

  private async removeFromDb(userId: number, locationId: number): Promise<LocationRecord[]> {
    const itineraryId = await this.getOrCreateItineraryId(userId);
    const pool = await getDbPool();
    const request = pool.request();
    request.input("itineraryId", sql.Int, itineraryId);
    request.input("locationId", sql.Int, locationId);

    await request.query(`
      DELETE FROM dbo.ChiTietLichTrinh
      WHERE [lich_trinh_id] = @itineraryId AND [dia_diem_id] = @locationId;
    `);

    return this.listFromDb(userId);
  }

  private async listFromDb(userId: number): Promise<LocationRecord[]> {
    const itineraryId = await this.getOrCreateItineraryId(userId);
    const pool = await getDbPool();
    const request = pool.request();
    request.input("itineraryId", sql.Int, itineraryId);

    const result = await request.query<LocationRecord>(`
      SELECT
        d.[dia_diem_id] AS id,
        d.[ten_dia_diem] AS name,
        c.[ma_danh_muc] AS categoryCode,
        c.[ten_danh_muc] AS categoryName,
        d.[dia_chi] AS address,
        d.[quan_huyen] AS district,
        d.[mo_ta] AS description,
        d.[anh_dai_dien] AS imageUrl,
        d.[dien_thoai] AS phone,
        d.[website] AS website,
        ISNULL(d.[diem_trung_binh], 0) AS rating,
        ISNULL(d.[tong_danh_gia], 0) AS totalReviews,
        d.[vi_do] AS latitude,
        d.[kinh_do] AS longitude,
        CAST(ISNULL(d.[noi_bat], 0) AS bit) AS featured,
        CASE
          WHEN p.[gia_trung_binh] IS NULL THEN NULL
          ELSE CONCAT(FORMAT(p.[gia_trung_binh], 'N0'), N' VND')
        END AS priceLabel,
        p.[gia_trung_binh] AS avgPriceVnd,
        d.[trang_thai] AS status
      FROM dbo.ChiTietLichTrinh i
      INNER JOIN dbo.DiaDiem d ON d.[dia_diem_id] = i.[dia_diem_id]
      INNER JOIN dbo.DanhMuc c ON c.[danh_muc_id] = d.[danh_muc_id]
      LEFT JOIN dbo.ThongTinGia p ON p.[dia_diem_id] = d.[dia_diem_id]
      WHERE i.[lich_trinh_id] = @itineraryId
      ORDER BY i.[thu_tu_tham_quan] ASC;
    `);

    return result.recordset;
  }

  private async getOrCreateItineraryId(userId: number): Promise<number> {
    const pool = await getDbPool();
    const request = pool.request();
    request.input("userId", sql.Int, userId);

    const existing = await request.query<{ itineraryId: number }>(`
      SELECT TOP 1 [lich_trinh_id] AS itineraryId
      FROM dbo.LichTrinh
      WHERE [nguoi_dung_id] = @userId
      ORDER BY [ngay_tao] ASC;
    `);

    const found = existing.recordset[0]?.itineraryId;
    if (found) {
      return found;
    }

    const created = await request.query<{ itineraryId: number }>(`
      INSERT INTO dbo.LichTrinh ([nguoi_dung_id], [tieu_de], [mo_ta], [cong_khai])
      VALUES (@userId, N'Hanh trinh mac dinh', N'Hanh trinh duoc tao tu thao tac luu nhanh tren web', 0);
      SELECT CAST(SCOPE_IDENTITY() AS INT) AS itineraryId;
    `);

    return created.recordset[0].itineraryId;
  }
}

export const itineraryService = new ItineraryService();
