-- =============================================================================
-- TRAVEL DESTINATION RECOMMENDATION WEBSITE - NORMALIZED DATABASE SCHEMA
-- Database: TravelRecommendation
-- Purpose: Central database for travel/tourism points of interest recommendation
-- Admin: 1 Admin user with full control
-- =============================================================================

-- ============================================================================
-- 1. USERS & AUTHENTICATION TABLE
-- ============================================================================

IF OBJECT_ID('dbo.NguoiDung', 'U') IS NOT NULL DROP TABLE dbo.NguoiDung;
CREATE TABLE dbo.NguoiDung (
    [nguoi_dung_id] INT IDENTITY(1,1) PRIMARY KEY,
    [ten_dang_nhap] NVARCHAR(100) NOT NULL UNIQUE,
    [email] NVARCHAR(255) NOT NULL UNIQUE,
    [mat_khau_bam] NVARCHAR(255) NOT NULL,
    [ho_ten] NVARCHAR(255) NOT NULL,
    [vai_tro] NVARCHAR(50) NOT NULL CHECK ([vai_tro] IN ('admin', 'moderator', 'user')),
    [trang_thai] NVARCHAR(50) NOT NULL DEFAULT 'active' CHECK ([trang_thai] IN ('active', 'inactive', 'banned')),
    [da_xac_thuc_email] BIT DEFAULT 0,
    [dang_nhap_cuoi] DATETIME2 NULL,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    [ngay_cap_nhat] DATETIME2 DEFAULT SYSUTCDATETIME()
);



-- ============================================================================
-- 2. LOCATION CATEGORIES TABLE
-- ============================================================================

IF OBJECT_ID('dbo.DanhMuc', 'U') IS NOT NULL DROP TABLE dbo.DanhMuc;
CREATE TABLE dbo.DanhMuc (
    [danh_muc_id] INT IDENTITY(1,1) PRIMARY KEY,
    [ten_danh_muc] NVARCHAR(100) NOT NULL,
    [ma_danh_muc] NVARCHAR(50) NOT NULL UNIQUE,
    [mo_ta] NVARCHAR(MAX) NULL,
    [bieu_tuong] NVARCHAR(100) NULL,
    [thu_tu_hien_thi] INT NOT NULL DEFAULT 0,
    [hoat_dong] BIT DEFAULT 1,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    [ngay_cap_nhat] DATETIME2 DEFAULT SYSUTCDATETIME()
);



-- ============================================================================
-- 3. LOCATIONS/PLACES TABLE (Main Content)
-- ============================================================================

IF OBJECT_ID('dbo.DiaDiem', 'U') IS NOT NULL DROP TABLE dbo.DiaDiem;
CREATE TABLE dbo.DiaDiem (
    [dia_diem_id] INT IDENTITY(1,1) PRIMARY KEY,
    [ten_dia_diem] NVARCHAR(255) NOT NULL,
    [danh_muc_id] INT NOT NULL,
    [dia_chi] NVARCHAR(500) NOT NULL,
    [quan_huyen] NVARCHAR(100) NULL,
    [thanh_pho] NVARCHAR(100) NOT NULL DEFAULT N'Thành phố Hồ Chí Minh',
    [ma_buu_chinh] NVARCHAR(20) NULL,
    [quoc_gia] NVARCHAR(100) NOT NULL DEFAULT N'Việt Nam',
    [vi_do] FLOAT NULL,
    [kinh_do] FLOAT NULL,
    [dien_thoai] NVARCHAR(50) NULL,
    [website] NVARCHAR(500) NULL,
    [email] NVARCHAR(255) NULL,
    [mo_ta] NVARCHAR(MAX) NULL,
    [anh_dai_dien] NVARCHAR(500) NULL,
    [diem_trung_binh] FLOAT DEFAULT 0,
    [tong_danh_gia] INT DEFAULT 0,
    [da_xac_minh] BIT DEFAULT 0,
    [hoat_dong] BIT DEFAULT 1,
    [noi_bat] BIT DEFAULT 0,
    [thu_tu_vi_tri] INT NULL,
    [trang_thai] NVARCHAR(50) NOT NULL DEFAULT 'pending' CHECK ([trang_thai] IN ('pending', 'approved', 'rejected', 'archived')),
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    [ngay_cap_nhat] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_Locations_Categories] FOREIGN KEY ([danh_muc_id]) REFERENCES dbo.DanhMuc([danh_muc_id])
);

CREATE INDEX [IX_Locations_CategoryId] ON dbo.DiaDiem([danh_muc_id]);
CREATE INDEX [IX_Locations_Status] ON dbo.DiaDiem([trang_thai]);
CREATE INDEX [IX_Locations_IsActive] ON dbo.DiaDiem([hoat_dong]);
CREATE INDEX [IX_Locations_Rating] ON dbo.DiaDiem([diem_trung_binh]);

-- ============================================================================
-- 4. OPERATING HOURS TABLE
-- ============================================================================

IF OBJECT_ID('dbo.GioHoatDong', 'U') IS NOT NULL DROP TABLE dbo.GioHoatDong;
CREATE TABLE dbo.GioHoatDong (
    [hour_id] INT IDENTITY(1,1) PRIMARY KEY,
    [dia_diem_id] INT NOT NULL,
    [thu_trong_tuan] INT NOT NULL CHECK ([thu_trong_tuan] BETWEEN 0 AND 6), -- 0=Sunday, 1=Monday, ..., 6=Saturday
    [ten_thu] NVARCHAR(20) NOT NULL,
    [gio_mo_cua] TIME NULL,
    [gio_dong_cua] TIME NULL,
    [dang_mo_cua] BIT DEFAULT 1,
    [ghi_chu] NVARCHAR(255) NULL,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_Hours_Locations] FOREIGN KEY ([dia_diem_id]) REFERENCES dbo.DiaDiem([dia_diem_id]) ON DELETE CASCADE
);

CREATE INDEX [IX_OperatingHours_LocationId] ON dbo.GioHoatDong([dia_diem_id]);

-- ============================================================================
-- 5. SERVICES/AMENITIES TABLE
-- ============================================================================

IF OBJECT_ID('dbo.DichVu', 'U') IS NOT NULL DROP TABLE dbo.DichVu;
CREATE TABLE dbo.DichVu (
    [dich_vu_id] INT IDENTITY(1,1) PRIMARY KEY,
    [ten_dich_vu] NVARCHAR(150) NOT NULL,
    [ma_dich_vu] NVARCHAR(50) NOT NULL UNIQUE,
    [mo_ta] NVARCHAR(MAX) NULL,
    [loai_dich_vu] NVARCHAR(50) NOT NULL, -- 'amenity', 'facility', 'service_option'
    [hoat_dong] BIT DEFAULT 1,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME()
);



-- ============================================================================
-- 6. LOCATION_SERVICES JUNCTION TABLE
-- ============================================================================

IF OBJECT_ID('dbo.DiaDiemDichVu', 'U') IS NOT NULL DROP TABLE dbo.DiaDiemDichVu;
CREATE TABLE dbo.DiaDiemDichVu (
    [dia_diem_dich_vu_id] INT IDENTITY(1,1) PRIMARY KEY,
    [dia_diem_id] INT NOT NULL,
    [dich_vu_id] INT NOT NULL,
    [san_sang] BIT DEFAULT 1,
    [ghi_chu] NVARCHAR(255) NULL,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_LocServices_Locations] FOREIGN KEY ([dia_diem_id]) REFERENCES dbo.DiaDiem([dia_diem_id]) ON DELETE CASCADE,
    CONSTRAINT [FK_LocServices_Services] FOREIGN KEY ([dich_vu_id]) REFERENCES dbo.DichVu([dich_vu_id]),
    CONSTRAINT [UQ_LocationService] UNIQUE ([dia_diem_id], [dich_vu_id])
);

CREATE INDEX [IX_LocationServices_LocationId] ON dbo.DiaDiemDichVu([dia_diem_id]);

-- ============================================================================
-- 7. PRICE INFORMATION TABLE
-- ============================================================================

IF OBJECT_ID('dbo.ThongTinGia', 'U') IS NOT NULL DROP TABLE dbo.ThongTinGia;
CREATE TABLE dbo.ThongTinGia (
    [gia_id] INT IDENTITY(1,1) PRIMARY KEY,
    [dia_diem_id] INT NOT NULL,
    [phan_khuc_gia] NVARCHAR(100) NOT NULL, -- 'budget', 'moderate', 'upscale', 'luxury'
    [gia_thap_nhat] DECIMAL(18, 2) NULL,
    [gia_cao_nhat] DECIMAL(18, 2) NULL,
    [gia_trung_binh] DECIMAL(18, 2) NULL,
    [don_vi_tien] NVARCHAR(10) NOT NULL DEFAULT N'VND',
    [mo_ta] NVARCHAR(255) NULL,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_Price_Locations] FOREIGN KEY ([dia_diem_id]) REFERENCES dbo.DiaDiem([dia_diem_id]) ON DELETE CASCADE,
    CONSTRAINT [UQ_LocationPrice] UNIQUE ([dia_diem_id], [phan_khuc_gia])
);

CREATE INDEX [IX_PriceInfo_LocationId] ON dbo.ThongTinGia([dia_diem_id]);

-- ============================================================================
-- 8. REVIEWS & RATINGS TABLE
-- ============================================================================

IF OBJECT_ID('dbo.DanhGia', 'U') IS NOT NULL DROP TABLE dbo.DanhGia;
CREATE TABLE dbo.DanhGia (
    [danh_gia_id] INT IDENTITY(1,1) PRIMARY KEY,
    [dia_diem_id] INT NOT NULL,
    [nguoi_dung_id] INT NULL,
    [ten_nguoi_danh_gia] NVARCHAR(100) NULL,
    [so_sao] INT NOT NULL CHECK ([so_sao] BETWEEN 1 AND 5),
    [tieu_de] NVARCHAR(255) NULL,
    [noi_dung_danh_gia] NVARCHAR(MAX) NULL,
    [so_luot_huu_ich] INT DEFAULT 0,
    [da_xac_thuc_ghe_tham] BIT DEFAULT 0,
    [trang_thai] NVARCHAR(50) NOT NULL DEFAULT 'pending' CHECK ([trang_thai] IN ('pending', 'approved', 'rejected')),
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    [ngay_cap_nhat] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_Reviews_Locations] FOREIGN KEY ([dia_diem_id]) REFERENCES dbo.DiaDiem([dia_diem_id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Reviews_Users] FOREIGN KEY ([nguoi_dung_id]) REFERENCES dbo.NguoiDung([nguoi_dung_id]) ON DELETE SET NULL
);

CREATE INDEX [IX_Reviews_LocationId] ON dbo.DanhGia([dia_diem_id]);
CREATE INDEX [IX_Reviews_UserId] ON dbo.DanhGia([nguoi_dung_id]);
CREATE INDEX [IX_Reviews_Status] ON dbo.DanhGia([trang_thai]);
CREATE INDEX [IX_Reviews_Rating] ON dbo.DanhGia([so_sao]);

-- ============================================================================
-- 9. IMAGES/GALLERY TABLE
-- ============================================================================

IF OBJECT_ID('dbo.HinhAnh', 'U') IS NOT NULL DROP TABLE dbo.HinhAnh;
CREATE TABLE dbo.HinhAnh (
    [hinh_anh_id] INT IDENTITY(1,1) PRIMARY KEY,
    [dia_diem_id] INT NOT NULL,
    [duong_dan_anh] NVARCHAR(500) NOT NULL,
    [tieu_de_anh] NVARCHAR(255) NULL,
    [mo_ta_anh] NVARCHAR(MAX) NULL,
    [loai_anh] NVARCHAR(50) NOT NULL DEFAULT 'gallery', -- 'thumbnail', 'gallery', 'hero'
    [thu_tu_hien_thi] INT NOT NULL DEFAULT 0,
    [anh_chinh] BIT DEFAULT 0,
    [tai_len_boi] INT NULL,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_Images_Locations] FOREIGN KEY ([dia_diem_id]) REFERENCES dbo.DiaDiem([dia_diem_id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Images_Users] FOREIGN KEY ([tai_len_boi]) REFERENCES dbo.NguoiDung([nguoi_dung_id]) ON DELETE SET NULL
);

CREATE INDEX [IX_Images_LocationId] ON dbo.HinhAnh([dia_diem_id]);
CREATE INDEX [IX_Images_IsPrimary] ON dbo.HinhAnh([anh_chinh]);

-- ============================================================================
-- 10. ADMIN ACTIVITY LOGS TABLE
-- ============================================================================

IF OBJECT_ID('dbo.NhatKyQuanTri', 'U') IS NOT NULL DROP TABLE dbo.NhatKyQuanTri;
CREATE TABLE dbo.NhatKyQuanTri (
    [nhat_ky_id] INT IDENTITY(1,1) PRIMARY KEY,
    [quan_tri_id] INT NOT NULL,
    [loai_hanh_dong] NVARCHAR(100) NOT NULL, -- 'create', 'update', 'delete', 'approve', 'reject', 'login', 'logout'
    [loai_doi_tuong] NVARCHAR(100) NOT NULL, -- 'location', 'review', 'user', 'category'
    [doi_tuong_id] INT NULL,
    [mo_ta] NVARCHAR(MAX) NULL,
    [gia_tri_cu] NVARCHAR(MAX) NULL,
    [gia_tri_moi] NVARCHAR(MAX) NULL,
    [dia_chi_ip] NVARCHAR(50) NULL,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_AdminLogs_Users] FOREIGN KEY ([quan_tri_id]) REFERENCES dbo.NguoiDung([nguoi_dung_id])
);

CREATE INDEX [IX_AdminLogs_AdminId] ON dbo.NhatKyQuanTri([quan_tri_id]);
CREATE INDEX [IX_AdminLogs_CreatedAt] ON dbo.NhatKyQuanTri([ngay_tao]);
CREATE INDEX [IX_AdminLogs_ActionType] ON dbo.NhatKyQuanTri([loai_hanh_dong]);

-- ============================================================================
-- 11. FAVORITES/BOOKMARKS TABLE
-- ============================================================================

IF OBJECT_ID('dbo.YeuThichNguoiDung', 'U') IS NOT NULL DROP TABLE dbo.YeuThichNguoiDung;
CREATE TABLE dbo.YeuThichNguoiDung (
    [yeu_thich_id] INT IDENTITY(1,1) PRIMARY KEY,
    [nguoi_dung_id] INT NOT NULL,
    [dia_diem_id] INT NOT NULL,
    [ghi_chu_ca_nhan] NVARCHAR(255) NULL,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_Favorites_Users] FOREIGN KEY ([nguoi_dung_id]) REFERENCES dbo.NguoiDung([nguoi_dung_id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Favorites_Locations] FOREIGN KEY ([dia_diem_id]) REFERENCES dbo.DiaDiem([dia_diem_id]) ON DELETE CASCADE,
    CONSTRAINT [UQ_UserFavorite] UNIQUE ([nguoi_dung_id], [dia_diem_id])
);

CREATE INDEX [IX_UserFavorites_UserId] ON dbo.YeuThichNguoiDung([nguoi_dung_id]);

-- ============================================================================
-- 12. TRAVEL ITINERARY TABLE
-- ============================================================================

IF OBJECT_ID('dbo.LichTrinh', 'U') IS NOT NULL DROP TABLE dbo.LichTrinh;
CREATE TABLE dbo.LichTrinh (
    [lich_trinh_id] INT IDENTITY(1,1) PRIMARY KEY,
    [nguoi_dung_id] INT NOT NULL,
    [tieu_de] NVARCHAR(255) NOT NULL,
    [mo_ta] NVARCHAR(MAX) NULL,
    [ngay_bat_dau] DATE NULL,
    [ngay_ket_thuc] DATE NULL,
    [cong_khai] BIT DEFAULT 0,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    [ngay_cap_nhat] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_Itinerary_Users] FOREIGN KEY ([nguoi_dung_id]) REFERENCES dbo.NguoiDung([nguoi_dung_id]) ON DELETE CASCADE
);

-- ============================================================================
-- 13. ITINERARY ITEMS TABLE
-- ============================================================================

IF OBJECT_ID('dbo.ChiTietLichTrinh', 'U') IS NOT NULL DROP TABLE dbo.ChiTietLichTrinh;
CREATE TABLE dbo.ChiTietLichTrinh (
    [chi_tiet_id] INT IDENTITY(1,1) PRIMARY KEY,
    [lich_trinh_id] INT NOT NULL,
    [dia_diem_id] INT NOT NULL,
    [ngay_thu] INT NOT NULL,
    [thu_tu_tham_quan] INT NOT NULL,
    [gio_bat_dau_tham_quan] TIME NULL,
    [thoi_luong_tham_quan_phut] INT NULL,
    [ghi_chu] NVARCHAR(MAX) NULL,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_ItineraryItems_Itinerary] FOREIGN KEY ([lich_trinh_id]) REFERENCES dbo.LichTrinh([lich_trinh_id]) ON DELETE CASCADE,
    CONSTRAINT [FK_ItineraryItems_Locations] FOREIGN KEY ([dia_diem_id]) REFERENCES dbo.DiaDiem([dia_diem_id])
);

CREATE INDEX [IX_ItineraryItems_ItineraryId] ON dbo.ChiTietLichTrinh([lich_trinh_id]);

-- ============================================================================
-- 14. SEO & METADATA TABLE
-- ============================================================================

IF OBJECT_ID('dbo.SeoDiaDiem', 'U') IS NOT NULL DROP TABLE dbo.SeoDiaDiem;
CREATE TABLE dbo.SeoDiaDiem (
    [seo_id] INT IDENTITY(1,1) PRIMARY KEY,
    [dia_diem_id] INT NOT NULL UNIQUE,
    [meta_tieu_de] NVARCHAR(255) NULL,
    [meta_mo_ta] NVARCHAR(500) NULL,
    [meta_tu_khoa] NVARCHAR(500) NULL,
    [duong_dan_tinh] NVARCHAR(255) NOT NULL UNIQUE,
    [lien_ket_chuan] NVARCHAR(500) NULL,
    [og_hinh_anh] NVARCHAR(500) NULL,
    [og_mo_ta] NVARCHAR(500) NULL,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    [ngay_cap_nhat] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_SEO_Locations] FOREIGN KEY ([dia_diem_id]) REFERENCES dbo.DiaDiem([dia_diem_id]) ON DELETE CASCADE
);

CREATE INDEX [IX_LocationSEO_Slug] ON dbo.SeoDiaDiem([duong_dan_tinh]);

-- ============================================================================
-- 15. ADMIN PANEL SETTINGS TABLE
-- ============================================================================

IF OBJECT_ID('dbo.CaiDatQuanTri', 'U') IS NOT NULL DROP TABLE dbo.CaiDatQuanTri;
CREATE TABLE dbo.CaiDatQuanTri (
    [cai_dat_id] INT IDENTITY(1,1) PRIMARY KEY,
    [khoa_cai_dat] NVARCHAR(100) NOT NULL UNIQUE,
    [gia_tri_cai_dat] NVARCHAR(MAX) NOT NULL,
    [loai_cai_dat] NVARCHAR(50) NOT NULL DEFAULT 'string', -- 'string', 'number', 'boolean', 'json'
    [mo_ta] NVARCHAR(255) NULL,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    [ngay_cap_nhat] DATETIME2 DEFAULT SYSUTCDATETIME()
);



-- ============================================================================
-- 16. STATISTICS & ANALYTICS TABLE
-- ============================================================================

IF OBJECT_ID('dbo.ThongKeDiaDiem', 'U') IS NOT NULL DROP TABLE dbo.ThongKeDiaDiem;
CREATE TABLE dbo.ThongKeDiaDiem (
    [thong_ke_id] INT IDENTITY(1,1) PRIMARY KEY,
    [dia_diem_id] INT NOT NULL,
    [luot_xem] INT DEFAULT 0,
    [luot_yeu_thich] INT DEFAULT 0,
    [luot_chia_se] INT DEFAULT 0,
    [luot_nhan_dien_thoai] INT DEFAULT 0,
    [luot_nhan_website] INT DEFAULT 0,
    [cap_nhat_lan_cuoi] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_Stats_Locations] FOREIGN KEY ([dia_diem_id]) REFERENCES dbo.DiaDiem([dia_diem_id]) ON DELETE CASCADE,
    CONSTRAINT [UQ_LocationStats] UNIQUE ([dia_diem_id])
);

-- ============================================================================
-- 17. USER PROFILE TABLE
-- ============================================================================

IF OBJECT_ID('dbo.HoSoNguoiDung', 'U') IS NOT NULL DROP TABLE dbo.HoSoNguoiDung;
CREATE TABLE dbo.HoSoNguoiDung (
    [ho_so_id] INT IDENTITY(1,1) PRIMARY KEY,
    [nguoi_dung_id] INT NOT NULL UNIQUE,
    [dien_thoai] NVARCHAR(20) NULL,
    [ngay_sinh] DATE NULL,
    [gioi_tinh] NVARCHAR(20) NULL CHECK ([gioi_tinh] IN (N'Nam', N'Nữ', N'Khác', NULL)),
    [dia_chi] NVARCHAR(500) NULL,
    [thanh_pho] NVARCHAR(100) NULL,
    [quan_huyen] NVARCHAR(100) NULL,
    [anh_dai_dien_url] NVARCHAR(500) NULL,
    [gioi_thieu] NVARCHAR(500) NULL,
    [tong_lich_trinh_tao] INT DEFAULT 0,
    [tong_danh_gia_da_dang] INT DEFAULT 0,
    [tong_yeu_thich] INT DEFAULT 0,
    [ngon_ngu_uu_tien] NVARCHAR(10) DEFAULT N'vi', -- 'vi', 'en'
    [mui_gio] NVARCHAR(50) NULL,
    [ngay_cap_nhat] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_UserProfile_Users] FOREIGN KEY ([nguoi_dung_id]) REFERENCES dbo.NguoiDung([nguoi_dung_id]) ON DELETE CASCADE
);

CREATE INDEX [IX_UserProfiles_UserId] ON dbo.HoSoNguoiDung([nguoi_dung_id]);

-- ============================================================================
-- 18. USER PREFERENCES TABLE (Sở thích khách hàng)
-- ============================================================================

IF OBJECT_ID('dbo.SoThichNguoiDung', 'U') IS NOT NULL DROP TABLE dbo.SoThichNguoiDung;
CREATE TABLE dbo.SoThichNguoiDung (
    [so_thich_id] INT IDENTITY(1,1) PRIMARY KEY,
    [nguoi_dung_id] INT NOT NULL,
    [danh_muc_id] INT NULL,
    [loai_so_thich] NVARCHAR(50) NOT NULL, -- 'favorite_category', 'favorite_service', 'price_range', 'trip_duration'
    [gia_tri_so_thich] NVARCHAR(255) NOT NULL,
    [diem_uu_tien] INT DEFAULT 0, -- 1-10 mức độ ưu tiên
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    [ngay_cap_nhat] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_UserPref_Users] FOREIGN KEY ([nguoi_dung_id]) REFERENCES dbo.NguoiDung([nguoi_dung_id]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserPref_Category] FOREIGN KEY ([danh_muc_id]) REFERENCES dbo.DanhMuc([danh_muc_id]) ON DELETE SET NULL
);

CREATE INDEX [IX_UserPreferences_UserId] ON dbo.SoThichNguoiDung([nguoi_dung_id]);
CREATE INDEX [IX_UserPreferences_PreferenceType] ON dbo.SoThichNguoiDung([loai_so_thich]);

-- ============================================================================
-- 19. CONVERSATIONS TABLE (Lịch sử trò chuyện khách hàng-AI)
-- ============================================================================

IF OBJECT_ID('dbo.CuocTroChuyen', 'U') IS NOT NULL DROP TABLE dbo.CuocTroChuyen;
CREATE TABLE dbo.CuocTroChuyen (
    [cuoc_tro_chuyen_id] INT IDENTITY(1,1) PRIMARY KEY,
    [nguoi_dung_id] INT NOT NULL,
    [tieu_de] NVARCHAR(255) NULL,
    [loai_ngu_canh] NVARCHAR(50) NOT NULL DEFAULT 'general', -- 'general', 'location_search', 'itinerary_planning', 'review_reading'
    [du_lieu_ngu_canh] NVARCHAR(MAX) NULL, -- JSON data for context
    [tong_tin_nhan] INT DEFAULT 0,
    [da_luu_tru] BIT DEFAULT 0,
    [trang_thai] NVARCHAR(50) NOT NULL DEFAULT 'active' CHECK ([trang_thai] IN ('active', 'archived', 'deleted')),
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    [tin_nhan_cuoi_luc] DATETIME2 NULL,
    [ngay_cap_nhat] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_Conversation_Users] FOREIGN KEY ([nguoi_dung_id]) REFERENCES dbo.NguoiDung([nguoi_dung_id]) ON DELETE CASCADE
);

CREATE INDEX [IX_Conversations_UserId] ON dbo.CuocTroChuyen([nguoi_dung_id]);
CREATE INDEX [IX_Conversations_CreatedAt] ON dbo.CuocTroChuyen([ngay_tao]);
CREATE INDEX [IX_Conversations_Status] ON dbo.CuocTroChuyen([trang_thai]);

-- ============================================================================
-- 20. CONVERSATION MESSAGES TABLE (Chi tiết từng tin nhắn trong cuộc trò chuyện)
-- ============================================================================

IF OBJECT_ID('dbo.TinNhanTroChuyen', 'U') IS NOT NULL DROP TABLE dbo.TinNhanTroChuyen;
CREATE TABLE dbo.TinNhanTroChuyen (
    [tin_nhan_id] INT IDENTITY(1,1) PRIMARY KEY,
    [cuoc_tro_chuyen_id] INT NOT NULL,
    [loai_nguoi_gui] NVARCHAR(20) NOT NULL CHECK ([loai_nguoi_gui] IN ('user', 'ai')), -- 'user' = khách hàng, 'ai' = AI assistant
    [noi_dung_tin_nhan] NVARCHAR(MAX) NOT NULL,
    [muc_dich_tin_nhan] NVARCHAR(100) NULL, -- 'search', 'recommendation', 'question', 'feedback', etc.
    [mo_hinh_ai_su_dung] NVARCHAR(100) NULL, -- tên model AI được sử dụng
    [diem_tu_tin] FLOAT NULL, -- độ tự tin của AI (0-1)
    [diem_phan_hoi_nguoi_dung] INT NULL CHECK ([diem_phan_hoi_nguoi_dung] BETWEEN 1 AND 5), -- người dùng đánh giá trả lời
    [huu_ich] BIT NULL, -- người dùng cho biết trả lời có hữu ích không
    [so_token] INT NULL, -- số token được sử dụng
    [thoi_gian_phan_hoi_ms] INT NULL, -- thời gian phản hồi (ms)
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_Message_Conversation] FOREIGN KEY ([cuoc_tro_chuyen_id]) REFERENCES dbo.CuocTroChuyen([cuoc_tro_chuyen_id]) ON DELETE CASCADE
);

CREATE INDEX [IX_ConversationMessages_ConversationId] ON dbo.TinNhanTroChuyen([cuoc_tro_chuyen_id]);
CREATE INDEX [IX_ConversationMessages_SenderType] ON dbo.TinNhanTroChuyen([loai_nguoi_gui]);
CREATE INDEX [IX_ConversationMessages_CreatedAt] ON dbo.TinNhanTroChuyen([ngay_tao]);

-- ============================================================================
-- 21. AI INTERACTION LOGS TABLE (Ghi log tương tác AI)
-- ============================================================================

IF OBJECT_ID('dbo.NhatKyTuongTacAI', 'U') IS NOT NULL DROP TABLE dbo.NhatKyTuongTacAI;
CREATE TABLE dbo.NhatKyTuongTacAI (
    [nhat_ky_id] INT IDENTITY(1,1) PRIMARY KEY,
    [nguoi_dung_id] INT NULL,
    [tin_nhan_id] INT NULL,
    [loai_hanh_dong] NVARCHAR(100) NOT NULL, -- 'location_recommendation', 'itinerary_suggestion', 'review_summarization', 'preference_learning'
    [tham_so_dau_vao] NVARCHAR(MAX) NULL, -- JSON
    [ket_qua_dau_ra] NVARCHAR(MAX) NULL, -- JSON
    [system_prompt_su_dung] NVARCHAR(MAX) NULL,
    [ten_mo_hinh] NVARCHAR(100) NULL,
    [thoi_gian_xu_ly_ms] INT NULL,
    [trang_thai] NVARCHAR(50) NOT NULL DEFAULT 'success' CHECK ([trang_thai] IN ('success', 'error', 'timeout')),
    [thong_bao_loi] NVARCHAR(MAX) NULL,
    [ngay_tao] DATETIME2 DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [FK_AILog_User] FOREIGN KEY ([nguoi_dung_id]) REFERENCES dbo.NguoiDung([nguoi_dung_id]) ON DELETE SET NULL,
    CONSTRAINT [FK_AILog_Message] FOREIGN KEY ([tin_nhan_id]) REFERENCES dbo.TinNhanTroChuyen([tin_nhan_id])
);

CREATE INDEX [IX_AILog_UserId] ON dbo.NhatKyTuongTacAI([nguoi_dung_id]);
CREATE INDEX [IX_AILog_ActionType] ON dbo.NhatKyTuongTacAI([loai_hanh_dong]);
CREATE INDEX [IX_AILog_CreatedAt] ON dbo.NhatKyTuongTacAI([ngay_tao]);

-- ============================================================================
-- CREATE VIEWS FOR EASY DATA RETRIEVAL
-- ============================================================================

IF OBJECT_ID('dbo.vw_LocationsWithDetails', 'V') IS NOT NULL DROP VIEW dbo.vw_LocationsWithDetails;
IF OBJECT_ID('dbo.vw_TopRatedLocations', 'V') IS NOT NULL DROP VIEW dbo.vw_TopRatedLocations;
IF OBJECT_ID('dbo.vw_FeaturedLocations', 'V') IS NOT NULL DROP VIEW dbo.vw_FeaturedLocations;
GO

-- View: All locations with category and rating info
CREATE VIEW dbo.vw_LocationsWithDetails AS
SELECT 
    l.[dia_diem_id],
    l.[ten_dia_diem],
    c.[ten_danh_muc],
    l.[dia_chi],
    l.[quan_huyen],
    l.[dien_thoai],
    l.[website],
    l.[diem_trung_binh],
    l.[tong_danh_gia],
    l.[vi_do],
    l.[kinh_do],
    l.[da_xac_minh],
    l.[noi_bat],
    l.[ngay_tao],
    l.[trang_thai]
FROM dbo.DiaDiem l
INNER JOIN dbo.DanhMuc c ON l.[danh_muc_id] = c.[danh_muc_id]
WHERE l.[hoat_dong] = 1 AND l.[trang_thai] = 'approved';
GO

-- View: Top rated locations
CREATE VIEW dbo.vw_TopRatedLocations AS
SELECT TOP 50
    l.[dia_diem_id],
    l.[ten_dia_diem],
    c.[ten_danh_muc],
    l.[diem_trung_binh],
    l.[tong_danh_gia],
    l.[dia_chi],
    l.[dien_thoai],
    l.[website]
FROM dbo.DiaDiem l
INNER JOIN dbo.DanhMuc c ON l.[danh_muc_id] = c.[danh_muc_id]
WHERE l.[hoat_dong] = 1 AND l.[trang_thai] = 'approved' AND l.[tong_danh_gia] > 0
ORDER BY l.[diem_trung_binh] DESC, l.[tong_danh_gia] DESC;
GO

-- View: Featured locations
CREATE VIEW dbo.vw_FeaturedLocations AS
SELECT 
    l.[dia_diem_id],
    l.[ten_dia_diem],
    c.[ten_danh_muc],
    l.[dia_chi],
    l.[diem_trung_binh],
    l.[tong_danh_gia],
    l.[anh_dai_dien],
    l.[vi_do],
    l.[kinh_do]
FROM dbo.DiaDiem l
INNER JOIN dbo.DanhMuc c ON l.[danh_muc_id] = c.[danh_muc_id]
WHERE l.[hoat_dong] = 1 AND l.[noi_bat] = 1 AND l.[trang_thai] = 'approved';
GO

-- ============================================================================
-- STORED PROCEDURES FOR ADMIN OPERATIONS
-- ============================================================================

IF OBJECT_ID('sp_ApproveLocation', 'P') IS NOT NULL DROP PROCEDURE sp_ApproveLocation;
IF OBJECT_ID('sp_UpdateLocationRating', 'P') IS NOT NULL DROP PROCEDURE sp_UpdateLocationRating;
IF OBJECT_ID('sp_GetLocationStatistics', 'P') IS NOT NULL DROP PROCEDURE sp_GetLocationStatistics;
IF OBJECT_ID('sp_GetPendingReviews', 'P') IS NOT NULL DROP PROCEDURE sp_GetPendingReviews;
GO

-- Procedure: Approve a location
CREATE PROCEDURE sp_ApproveLocation
    @LocationId INT,
    @AdminId INT,
    @Notes NVARCHAR(MAX) = NULL
AS
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE dbo.DiaDiem
    SET [trang_thai] = 'approved', [ngay_cap_nhat] = SYSUTCDATETIME()
    WHERE [dia_diem_id] = @LocationId;
    
    INSERT INTO dbo.NhatKyQuanTri ([quan_tri_id], [loai_hanh_dong], [loai_doi_tuong], [doi_tuong_id], [mo_ta])
    VALUES (@AdminId, 'approve', 'location', @LocationId, @Notes);
    
    COMMIT TRANSACTION;
END;
GO

-- Procedure: Update location rating dynamically
CREATE PROCEDURE sp_UpdateLocationRating
    @LocationId INT
AS
BEGIN
    DECLARE @AvgRating FLOAT, @ReviewCount INT;
    
    SELECT 
        @AvgRating = AVG(CAST([so_sao] AS FLOAT)),
        @ReviewCount = COUNT(*)
    FROM dbo.DanhGia
    WHERE [dia_diem_id] = @LocationId AND [trang_thai] = 'approved';
    
    UPDATE dbo.DiaDiem
    SET 
        [diem_trung_binh] = ISNULL(@AvgRating, 0),
        [tong_danh_gia] = ISNULL(@ReviewCount, 0)
    WHERE [dia_diem_id] = @LocationId;
END;
GO

-- Procedure: Get location statistics
CREATE PROCEDURE sp_GetLocationStatistics
AS
BEGIN
    SELECT 
        c.[ten_danh_muc],
        COUNT(l.[dia_diem_id]) AS [total_locations],
        ROUND(AVG(l.[diem_trung_binh]), 2) AS [avg_rating],
        SUM(ls.[luot_xem]) AS [total_views],
        SUM(ls.[luot_yeu_thich]) AS [tong_yeu_thich]
    FROM dbo.DanhMuc c
    LEFT JOIN dbo.DiaDiem l ON c.[danh_muc_id] = l.[danh_muc_id] AND l.[trang_thai] = 'approved'
    LEFT JOIN dbo.ThongKeDiaDiem ls ON l.[dia_diem_id] = ls.[dia_diem_id]
    WHERE c.[hoat_dong] = 1
    GROUP BY c.[danh_muc_id], c.[ten_danh_muc]
    ORDER BY [total_locations] DESC;
END;
GO

-- Procedure: Get pending reviews for moderation
CREATE PROCEDURE sp_GetPendingReviews
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    DECLARE @Skip INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        r.[danh_gia_id],
        r.[dia_diem_id],
        l.[ten_dia_diem],
        r.[ten_nguoi_danh_gia],
        r.[so_sao],
        r.[tieu_de],
        r.[noi_dung_danh_gia],
        r.[ngay_tao]
    FROM dbo.DanhGia r
    INNER JOIN dbo.DiaDiem l ON r.[dia_diem_id] = l.[dia_diem_id]
    WHERE r.[trang_thai] = 'pending'
    ORDER BY r.[ngay_tao] DESC
    OFFSET @Skip ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

-- ============================================================================
-- PRINT SUCCESS MESSAGE
-- ============================================================================

PRINT '=============================================================================';
PRINT 'Database schema created successfully!';
PRINT '=============================================================================';
PRINT '';
PRINT 'Created Tables:';
PRINT '  1. Users - User accounts and authentication';
PRINT '  2. Categories - Location categories';
PRINT '  3. Locations - Main places/points of interest';
PRINT '  4. OperatingHours - Business hours by day';
PRINT '  5. Services - Available services and amenities';
PRINT '  6. LocationServices - Services at each location';
PRINT '  7. PriceInfo - Price ranges';
PRINT '  8. Reviews - User reviews and ratings';
PRINT '  9. Images - Photos and galleries';
PRINT ' 10. AdminLogs - Admin activity tracking';
PRINT ' 11. UserFavorites - Bookmarked locations';
PRINT ' 12. Itineraries - Travel plans';
PRINT ' 13. ItineraryItems - Locations in travel plans';
PRINT ' 14. LocationSEO - SEO metadata';
PRINT ' 15. AdminSettings - Configuration settings';
PRINT ' 16. LocationStats - View and engagement stats';
PRINT ' 17. UserProfiles - Customer profile information';
PRINT ' 18. UserPreferences - Customer preferences/interests (Sở thích)';
PRINT ' 19. Conversations - Customer-AI chat conversation history';
PRINT ' 20. ConversationMessages - Individual messages in conversations';
PRINT ' 21. AIInteractionLogs - AI interaction logs and analytics';
PRINT '';
PRINT 'Default Admin User:';
PRINT '  Username: admin';
PRINT '  Email: admin@travelrecommendation.vn';
PRINT '  Role: admin';
PRINT '  (Change password after first login)';
PRINT '';
PRINT 'Created Views:';
PRINT '  - vw_LocationsWithDetails';
PRINT '  - vw_TopRatedLocations';
PRINT '  - vw_FeaturedLocations';
PRINT '';
PRINT 'Created Stored Procedures:';
PRINT '  - sp_ApproveLocation';
PRINT '  - sp_UpdateLocationRating';
PRINT '  - sp_GetLocationStatistics';
PRINT '  - sp_GetPendingReviews';
PRINT '=============================================================================';

