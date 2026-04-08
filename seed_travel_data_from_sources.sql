-- ============================================================================
-- Seed data into normalized schema (TravelRecommendation)
-- NOTE:
--   1) Run schema_travel_recommendation.sql first
--   2) Source raw tables are optional; existing tables will be imported
-- This script ONLY inserts data into existing normalized tables.
-- ============================================================================

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- ------------------------------------------------------------------------
    -- 0) Build temp source data safely (no invalid object error)
    -- ------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#SourceData') IS NOT NULL DROP TABLE #SourceData;

    CREATE TABLE #SourceData (
        ma_danh_muc NVARCHAR(50) NOT NULL,
        ten_dia_diem NVARCHAR(255) NULL,
        dia_chi NVARCHAR(1000) NULL,
        quan_huyen NVARCHAR(100) NULL,
        vi_do FLOAT NULL,
        kinh_do FLOAT NULL,
        dien_thoai NVARCHAR(255) NULL,
        website NVARCHAR(2000) NULL,
        mo_ta NVARCHAR(MAX) NULL,
        anh_dai_dien NVARCHAR(2000) NULL,
        diem_trung_binh FLOAT NULL,
        tong_danh_gia INT NULL,
        thu_tu_vi_tri INT NULL,
        gia_trung_binh DECIMAL(18,2) NULL,
        raw_price_text NVARCHAR(255) NULL,
        operating_hours_json NVARCHAR(MAX) NULL,
        hours_text NVARCHAR(255) NULL
    );

    IF OBJECT_ID('dbo.cho_go_vap_vi', 'U') IS NOT NULL
    BEGIN
        INSERT INTO #SourceData
        SELECT
            N'cho', s.[title], s.[address], N'Gò Vấp',
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.latitude') AS FLOAT),
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.longitude') AS FLOAT),
            s.[phone], s.[website], s.[description], s.[thumbnail],
            TRY_CAST(s.[rating] AS FLOAT), TRY_CAST(s.[reviews] AS INT), TRY_CAST(s.[position] AS INT),
            TRY_CAST(NULL AS DECIMAL(18,2)), NULL, s.[operating_hours], s.[hours]
        FROM dbo.cho_go_vap_vi s;
    END;

    IF OBJECT_ID('dbo.chua_go_vap_vi', 'U') IS NOT NULL
    BEGIN
        INSERT INTO #SourceData
        SELECT
            N'chua', s.[title], s.[address], N'Gò Vấp',
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.latitude') AS FLOAT),
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.longitude') AS FLOAT),
            s.[phone], s.[website], s.[description], s.[thumbnail],
            TRY_CAST(s.[rating] AS FLOAT), TRY_CAST(s.[reviews] AS INT), TRY_CAST(s.[position] AS INT),
            TRY_CAST(NULL AS DECIMAL(18,2)), NULL, s.[operating_hours], s.[hours]
        FROM dbo.chua_go_vap_vi s;
    END;

    IF OBJECT_ID('dbo.coffee_go_vap', 'U') IS NOT NULL
    BEGIN
        INSERT INTO #SourceData
        SELECT
            N'coffee', s.[title], s.[address], N'Gò Vấp',
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.latitude') AS FLOAT),
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.longitude') AS FLOAT),
            s.[phone], s.[website], TRY_CAST(NULL AS NVARCHAR(MAX)), s.[thumbnail],
            TRY_CAST(s.[rating] AS FLOAT), TRY_CAST(s.[reviews] AS INT), TRY_CAST(s.[position] AS INT),
            TRY_CAST(COALESCE(s.[average_price_vnd], s.[extracted_price]) AS DECIMAL(18,2)), s.[price], s.[operating_hours], s.[hours]
        FROM dbo.coffee_go_vap s;
    END;

    IF OBJECT_ID('dbo.congvien_go_vap_vi', 'U') IS NOT NULL
    BEGIN
        INSERT INTO #SourceData
        SELECT
            N'cong-vien', s.[title], s.[address], N'Gò Vấp',
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.latitude') AS FLOAT),
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.longitude') AS FLOAT),
            s.[phone], s.[website], s.[description], s.[thumbnail],
            TRY_CAST(s.[rating] AS FLOAT), TRY_CAST(s.[reviews] AS INT), TRY_CAST(s.[position] AS INT),
            TRY_CAST(NULL AS DECIMAL(18,2)), NULL, s.[operating_hours], s.[hours]
        FROM dbo.congvien_go_vap_vi s;
    END;

    IF OBJECT_ID('dbo.karaoke_go_vap_vi', 'U') IS NOT NULL
    BEGIN
        INSERT INTO #SourceData
        SELECT
            N'karaoke', s.[title], s.[address], N'Gò Vấp',
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.latitude') AS FLOAT),
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.longitude') AS FLOAT),
            s.[phone], s.[website], TRY_CAST(NULL AS NVARCHAR(MAX)), s.[thumbnail],
            TRY_CAST(s.[rating] AS FLOAT), TRY_CAST(s.[reviews] AS INT), TRY_CAST(s.[position] AS INT),
            TRY_CAST(s.[extracted_price] AS DECIMAL(18,2)), s.[price], s.[operating_hours], s.[hours]
        FROM dbo.karaoke_go_vap_vi s;
    END;

    IF OBJECT_ID('dbo.nhatho_go_vap_vi', 'U') IS NOT NULL
    BEGIN
        INSERT INTO #SourceData
        SELECT
            N'nha-tho', s.[title], s.[address], N'Gò Vấp',
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.latitude') AS FLOAT),
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.longitude') AS FLOAT),
            s.[phone], s.[website], s.[description], s.[thumbnail],
            TRY_CAST(s.[rating] AS FLOAT), TRY_CAST(s.[reviews] AS INT), TRY_CAST(s.[position] AS INT),
            TRY_CAST(NULL AS DECIMAL(18,2)), NULL, s.[operating_hours], s.[hours]
        FROM dbo.nhatho_go_vap_vi s;
    END;

    IF OBJECT_ID('dbo.quanan_go_vap_vi', 'U') IS NOT NULL
    BEGIN
        INSERT INTO #SourceData
        SELECT
            N'quan-an', s.[title], s.[address], N'Gò Vấp',
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.latitude') AS FLOAT),
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.longitude') AS FLOAT),
            s.[phone], s.[website], s.[description], s.[thumbnail],
            TRY_CAST(s.[rating] AS FLOAT), TRY_CAST(s.[reviews] AS INT), TRY_CAST(s.[position] AS INT),
            TRY_CAST(COALESCE(s.[average_price], s.[extracted_price]) AS DECIMAL(18,2)), s.[price], s.[operating_hours], s.[hours]
        FROM dbo.quanan_go_vap_vi s;
    END;

    IF OBJECT_ID('dbo.thuexe_go_vap_vi', 'U') IS NOT NULL
    BEGIN
        INSERT INTO #SourceData
        SELECT
            N'thue-xe', s.[title], s.[address], N'Gò Vấp',
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.latitude') AS FLOAT),
            TRY_CAST(JSON_VALUE(s.[gps_coordinates], '$.longitude') AS FLOAT),
            s.[phone], s.[website], TRY_CAST(NULL AS NVARCHAR(MAX)), s.[thumbnail],
            TRY_CAST(s.[rating] AS FLOAT), TRY_CAST(s.[reviews] AS INT), TRY_CAST(s.[position] AS INT),
            TRY_CAST(NULL AS DECIMAL(18,2)), NULL, s.[operating_hours], s.[hours]
        FROM dbo.thuexe_go_vap_vi s;
    END;

    IF OBJECT_ID('dbo.hotels_go_vap', 'U') IS NOT NULL
    BEGIN
        INSERT INTO #SourceData
        SELECT
            N'khach-san', s.[title], s.[address], N'Gò Vấp',
            TRY_CAST(NULL AS FLOAT), TRY_CAST(NULL AS FLOAT),
            s.[phone], s.[website], TRY_CAST(NULL AS NVARCHAR(MAX)), s.[img],
            TRY_CAST(s.[rating] AS FLOAT), TRY_CAST(NULL AS INT), TRY_CAST(NULL AS INT),
            TRY_CAST(s.[price_vnd] AS DECIMAL(18,2)), s.[price_text], TRY_CAST(NULL AS NVARCHAR(MAX)), TRY_CAST(NULL AS NVARCHAR(255))
        FROM dbo.hotels_go_vap s;
    END;

    IF NOT EXISTS (SELECT 1 FROM #SourceData)
    BEGIN
        THROW 50001, N'Không tìm thấy bảng nguồn raw (cho_go_vap_vi/chua_go_vap_vi/.../hotels_go_vap). Hãy import dữ liệu raw trước.', 1;
    END;

    -- ------------------------------------------------------------------------
    -- 1) Seed categories (DanhMuc)
    -- ------------------------------------------------------------------------
    ;WITH CategorySeed AS (
        SELECT N'Chợ' AS ten_danh_muc, N'cho' AS ma_danh_muc, N'Chợ dân sinh, chợ thực phẩm, khu mua sắm' AS mo_ta, N'store' AS bieu_tuong, 1 AS thu_tu_hien_thi
        UNION ALL SELECT N'Chùa', N'chua', N'Địa điểm tâm linh, chùa chiền', N'temple', 2
        UNION ALL SELECT N'Quán cà phê', N'coffee', N'Quán cà phê và điểm uống nước', N'coffee', 3
        UNION ALL SELECT N'Công viên', N'cong-vien', N'Công viên và điểm vui chơi ngoài trời', N'park', 4
        UNION ALL SELECT N'Karaoke', N'karaoke', N'Địa điểm karaoke, giải trí', N'mic', 5
        UNION ALL SELECT N'Nhà thờ', N'nha-tho', N'Địa điểm tôn giáo - nhà thờ', N'church', 6
        UNION ALL SELECT N'Quán ăn', N'quan-an', N'Nhà hàng, quán ăn', N'utensils', 7
        UNION ALL SELECT N'Thuê xe', N'thue-xe', N'Dịch vụ thuê xe và di chuyển', N'car', 8
        UNION ALL SELECT N'Khách sạn', N'khach-san', N'Khách sạn, lưu trú', N'hotel', 9
    )
    INSERT INTO dbo.DanhMuc ([ten_danh_muc], [ma_danh_muc], [mo_ta], [bieu_tuong], [thu_tu_hien_thi], [hoat_dong])
    SELECT c.ten_danh_muc, c.ma_danh_muc, c.mo_ta, c.bieu_tuong, c.thu_tu_hien_thi, 1
    FROM CategorySeed c
    WHERE NOT EXISTS (SELECT 1 FROM dbo.DanhMuc d WHERE d.[ma_danh_muc] = c.ma_danh_muc);

    -- ------------------------------------------------------------------------
    -- 2) Insert places into DiaDiem
    -- ------------------------------------------------------------------------
    INSERT INTO dbo.DiaDiem (
        [ten_dia_diem], [danh_muc_id], [dia_chi], [quan_huyen], [vi_do], [kinh_do],
        [dien_thoai], [website], [mo_ta], [anh_dai_dien], [diem_trung_binh], [tong_danh_gia],
        [da_xac_minh], [hoat_dong], [noi_bat], [thu_tu_vi_tri], [trang_thai]
    )
    SELECT
        LEFT(src.ten_dia_diem, 255), dm.[danh_muc_id], LEFT(src.dia_chi, 500), LEFT(src.quan_huyen, 100), src.vi_do, src.kinh_do,
        LEFT(src.dien_thoai, 50), LEFT(src.website, 500), src.mo_ta, LEFT(src.anh_dai_dien, 500),
        ISNULL(src.diem_trung_binh, 0), ISNULL(src.tong_danh_gia, 0),
        1, 1,
        CASE WHEN ISNULL(src.diem_trung_binh, 0) >= 4.5 AND ISNULL(src.tong_danh_gia, 0) >= 100 THEN 1 ELSE 0 END,
        src.thu_tu_vi_tri,
        'approved'
    FROM #SourceData src
    INNER JOIN dbo.DanhMuc dm ON dm.[ma_danh_muc] = src.ma_danh_muc
    WHERE src.ten_dia_diem IS NOT NULL
      AND src.dia_chi IS NOT NULL
      AND NOT EXISTS (
            SELECT 1 FROM dbo.DiaDiem dd
                        WHERE dd.[ten_dia_diem] = LEFT(src.ten_dia_diem, 255)
                            AND dd.[dia_chi] = LEFT(src.dia_chi, 500)
        );

    -- ------------------------------------------------------------------------
    -- 3) Insert/update price data into ThongTinGia (price is mandatory if exists)
    -- ------------------------------------------------------------------------
    -- ------------------------------------------------------------------------
-- 3) Insert/update price data into ThongTinGia (Sửa lỗi trùng lặp UNIQUE KEY)
-- ------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#PriceRows') IS NOT NULL DROP TABLE #PriceRows;

;WITH PricePrepared AS (
    SELECT
        src.ten_dia_diem,
        src.dia_chi,
        src.gia_trung_binh AS gia_numeric,
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(ISNULL(src.raw_price_text, N'')), N'₫', N''), N'đ', N''), N'vnd', N''), N' ', N''), N',', N''), N'.', N''), N'–', N'-'), N'—', N'-') AS gia_text_norm
    FROM #SourceData src
), PriceParsed AS (
    SELECT
        p.ten_dia_diem,
        p.dia_chi,
        COALESCE(
            p.gia_numeric,
            CASE
                WHEN CHARINDEX(N'-', p.gia_text_norm) > 0 THEN
                    (
                        COALESCE(TRY_CAST(NULLIF(LEFT(p.gia_text_norm, CHARINDEX(N'-', p.gia_text_norm) - 1), N'') AS DECIMAL(18,2)), 0)
                        + COALESCE(TRY_CAST(NULLIF(SUBSTRING(p.gia_text_norm, CHARINDEX(N'-', p.gia_text_norm) + 1, 255), N'') AS DECIMAL(18,2)), 0)
                    ) / 2.0
                ELSE TRY_CAST(NULLIF(p.gia_text_norm, N'') AS DECIMAL(18,2))
            END
        ) AS gia_clean
    FROM PricePrepared p
), DistinctPrices AS (
    -- LỌC TRÙNG: Chỉ lấy 1 giá duy nhất cho mỗi ID địa điểm
    SELECT 
        dd.[dia_diem_id],
        CAST(pp.gia_clean AS DECIMAL(18,2)) AS gia_clean,
        ROW_NUMBER() OVER (PARTITION BY dd.[dia_diem_id] ORDER BY pp.gia_clean DESC) as rn
    FROM PriceParsed pp
    INNER JOIN dbo.DiaDiem dd
          ON dd.[ten_dia_diem] = LEFT(pp.ten_dia_diem, 255)
         AND dd.[dia_chi] = LEFT(pp.dia_chi, 500)
    WHERE pp.gia_clean IS NOT NULL AND pp.gia_clean > 0
)
SELECT dia_diem_id, gia_clean
INTO #PriceRows
FROM DistinctPrices
WHERE rn = 1; -- Chỉ lấy dòng đầu tiên nếu có nhiều giá cho 1 địa điểm

-- Sau đó chạy lệnh MERGE như cũ
MERGE dbo.ThongTinGia AS target
USING #PriceRows AS src
   ON target.[dia_diem_id] = src.[dia_diem_id]
  AND target.[phan_khuc_gia] = N'standard'
WHEN MATCHED THEN
    UPDATE SET
        target.[gia_thap_nhat] = src.gia_clean,
        target.[gia_cao_nhat] = src.gia_clean,
        target.[gia_trung_binh] = src.gia_clean,
        target.[don_vi_tien] = N'VND',
        target.[mo_ta] = N'Dữ liệu giá import từ nguồn ban đầu'
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([dia_diem_id], [phan_khuc_gia], [gia_thap_nhat], [gia_cao_nhat], [gia_trung_binh], [don_vi_tien], [mo_ta])
    VALUES (src.[dia_diem_id], N'standard', src.gia_clean, src.gia_clean, src.gia_clean, N'VND', N'Dữ liệu giá import từ nguồn ban đầu');
    -- ------------------------------------------------------------------------
    -- 4) Insert operating-hours text into GioHoatDong
    -- ------------------------------------------------------------------------
    ;WITH Parsed AS (
        SELECT
            dd.[dia_diem_id],
            j.[key] AS day_key,
            CAST(j.[value] AS NVARCHAR(255)) AS day_text
        FROM #SourceData sh
        INNER JOIN dbo.DiaDiem dd
            ON dd.[ten_dia_diem] = LEFT(sh.ten_dia_diem, 255)
           AND dd.[dia_chi] = LEFT(sh.dia_chi, 500)
        CROSS APPLY OPENJSON(sh.operating_hours_json) j
        WHERE ISJSON(sh.operating_hours_json) = 1
    )
    INSERT INTO dbo.GioHoatDong (
        [dia_diem_id], [thu_trong_tuan], [ten_thu], [gio_mo_cua], [gio_dong_cua], [dang_mo_cua], [ghi_chu]
    )
    SELECT
        p.[dia_diem_id],
        CASE p.day_key
            WHEN N'chu_nhat' THEN 0
            WHEN N'thu_hai' THEN 1
            WHEN N'thu_ba' THEN 2
            WHEN N'thu_tu' THEN 3
            WHEN N'thu_nam' THEN 4
            WHEN N'thu_sau' THEN 5
            WHEN N'thu_bay' THEN 6
            ELSE 0
        END,
        CASE p.day_key
            WHEN N'chu_nhat' THEN N'Chủ nhật'
            WHEN N'thu_hai' THEN N'Thứ hai'
            WHEN N'thu_ba' THEN N'Thứ ba'
            WHEN N'thu_tu' THEN N'Thứ tư'
            WHEN N'thu_nam' THEN N'Thứ năm'
            WHEN N'thu_sau' THEN N'Thứ sáu'
            WHEN N'thu_bay' THEN N'Thứ bảy'
            ELSE N'Không rõ'
        END,
        NULL,
        NULL,
        CASE WHEN p.day_text LIKE N'%Đóng cửa%' THEN 0 ELSE 1 END,
        p.day_text
    FROM Parsed p
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.GioHoatDong gh
        WHERE gh.[dia_diem_id] = p.[dia_diem_id]
          AND gh.[thu_trong_tuan] = CASE p.day_key
                WHEN N'chu_nhat' THEN 0
                WHEN N'thu_hai' THEN 1
                WHEN N'thu_ba' THEN 2
                WHEN N'thu_tu' THEN 3
                WHEN N'thu_nam' THEN 4
                WHEN N'thu_sau' THEN 5
                WHEN N'thu_bay' THEN 6
                ELSE 0
              END
    );

    -- ------------------------------------------------------------------------
    -- 5) Seed statistics table for all imported places
    -- ------------------------------------------------------------------------
    INSERT INTO dbo.ThongKeDiaDiem (
        [dia_diem_id], [luot_xem], [luot_yeu_thich], [luot_chia_se], [luot_nhan_dien_thoai], [luot_nhan_website]
    )
    SELECT d.[dia_diem_id], 0, 0, 0, 0, 0
    FROM dbo.DiaDiem d
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.ThongKeDiaDiem tk WHERE tk.[dia_diem_id] = d.[dia_diem_id]
    );

    COMMIT TRANSACTION;

    PRINT N'============================================================';
    PRINT N'Import dữ liệu vào schema chuẩn đã hoàn tất.';
    PRINT N'Đã insert vào: DanhMuc, DiaDiem, ThongTinGia, GioHoatDong, ThongKeDiaDiem';
    PRINT N'============================================================';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrLine INT = ERROR_LINE();
    DECLARE @ErrNum INT = ERROR_NUMBER();

    PRINT N'Lỗi khi import dữ liệu!';
    PRINT N'Error ' + CAST(@ErrNum AS NVARCHAR(20)) + N' at line ' + CAST(@ErrLine AS NVARCHAR(20));
    PRINT @ErrMsg;

    THROW;
END CATCH;
