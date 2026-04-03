# Tài Liệu Thiết Kế Cơ Sở Dữ Liệu
## Website Gợi Ý Điểm Du Lịch

---

## 📋 MỤC LỤC
1. [Tổng Quan](#tổng-quan)
2. [Sơ Đồ Quan Hệ Thực Thể (ER Diagram)](#sơ-đồ-quan-hệ-thực-thể)
3. [Chi Tiết Các Bảng Dữ Liệu](#chi-tiết-các-bảng-dữ-liệu)
4. [Ghi Chú Thiết Kế](#ghi-chú-thiết-kế)
5. [Quyền Admin](#quyền-admin)
6. [Ví Dụ Truy Vấn](#ví-dụ-truy-vấn)

---

## Tổng Quan

### Mục Đích
Cơ sở dữ liệu này được thiết kế cho một website gợi ý điểm du lịch, nhà hàng, và các dịch vụ tại Gò Vấp với:
- **1 Admin** có toàn quyền quản lý
- **Chuẩn hóa dữ liệu** (Normalized) để tránh lặp lại dữ liệu
- **Quan hệ rõ ràng** giữa các bảng
- **Khóa ngoài** để đảm bảo tính toàn vẹn dữ liệu
- **Chỉ mục tối ưu** để tăng hiệu suất truy vấn

### Đặc Điểm Chính
- ✅ Hỗ trợ 8+ loại địa điểm du lịch
- ✅ Hệ thống đánh giá và bình luận duyệt phê
- ✅ Quản lý giờ hoạt động linh hoạt (theo ngày)
- ✅ Hỗ trợ dịch vụ/tiện nghi đa dạng
- ✅ Lịch sử hoạt động admin
- ✅ Quản lý hình ảnh/thư viện
- ✅ Hỗ trợ lịch trình du lịch
- ✅ SEO metadata
- ✅ Thống kê lượt xem

---

## Sơ Đồ Quan Hệ Thực Thể

```
┌─────────────────────────────────────────────────────────────────────┐
│                          USERS (Người Dùng)                         │
│  user_id (PK) | username | email | password_hash | role | status    │
│                                                                     │
│  role: 'admin', 'moderator', 'user'                                 │
│  status: 'active', 'inactive', 'banned'                             │
└────────────────────┬────────────────────────────────────────────────┘
                     │
        ┌────────────┼────────────────┐
        │            │                │
        ▼            ▼                ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────────┐
│  AdminLogs   │  │   Reviews    │  │ UserFavorites    │
│  (Lịch Sử)   │  │  (Bình Luận) │  │  (Yêu Thích)     │
└──────────────┘  └──────────────┘  └──────────────────┘
                        │
                        │ location_id
                        ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   CATEGORIES (Loại Địa Điểm)                        │
│  category_id (PK) | category_name | category_code | display_order   │
│                                                                     │
│  Ví dụ: Nhà Hàng, Công Viên, Dịch Vụ Cho Thuê Xe, ...             │
└────┬────────────────────────────────────────────────────────────────┘
     │
     │ category_id
     ▼
┌─────────────────────────────────────────────────────────────────────┐
│               LOCATIONS (Địa Điểm Du Lịch - Chính)                 │
│  location_id (PK) | location_name | category_id (FK)                │
│  address | latitude | longitude | phone | website                  │
│  average_rating | total_reviews | is_verified | status            │
│                                                                     │
│  status: 'pending', 'approved', 'rejected', 'archived'             │
└────┬──────────────┬────────────────┬───────────────┬────────────────┘
     │              │                │               │
     │              │                │               │
     ▼              ▼                ▼               ▼
┌─────────────────────────────┐  ┌──────────────┐  ┌────────────────┐
│   OperatingHours            │  │  Services    │  │   Images       │
│  (Giờ Hoạt Động)            │  │ (Dịch Vụ)    │  │  (Hình Ảnh)    │
│  day_of_week (0-6)          │  │              │  │                │
│  opening_time, closing_time │  │              │  │ image_type:    │
└─────────────────────────────┘  └────┬─────────┘  │ 'thumbnail'    │
                                      │            │ 'gallery'      │
                              ┌───────▼────────┐  │ 'hero'         │
                              │LocationServices│  │                │
                              │(Bảng Nối)      │  └────────────────┘
                              └────────────────┘
                                    
                     ┌──────────────────────────┐
                     │     PriceInfo            │
                     │   (Thông Tin Giá)        │
                     │  price_category:         │
                     │  'budget' | 'moderate'   │
                     │  'upscale' | 'luxury'    │
                     └──────────────────────────┘
                     
                     ┌──────────────────────────┐
                     │    LocationStats         │
                     │  (Thống Kê Lượt Xem)     │
                     │  view_count, favorite_   │
                     │  count, share_count      │
                     └──────────────────────────┘
                     
                     ┌──────────────────────────┐
                     │   LocationSEO            │
                     │  (SEO Metadata)          │
                     │  slug, meta_title        │
                     │  meta_description        │
                     └──────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│               ITINERARIES (Lịch Trình Du Lịch)                      │
│  itinerary_id | user_id (FK) | title | start_date | end_date        │
│                                                                     │
│  ItineraryItems (Địa Điểm Trong Lịch Trình)                        │
│  item_id | itinerary_id | location_id | day_number | visit_order    │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│            ADMIN MANAGEMENT                                         │
│                                                                     │
│  AdminSettings (Cấu Hình Hệ Thống)                                   │
│  setting_key | setting_value | setting_type                        │
│                                                                     │
│  Ví dụ: site_name, items_per_page, require_review_approval         │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Chi Tiết Các Bảng Dữ Liệu

### 1️⃣ Users (Người Dùng)
```
Cột                Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
user_id (PK)       INT               Mã người dùng (tự tăng)
username           NVARCHAR(100)     Tên đăng nhập (duy nhất)
email              NVARCHAR(255)     Email (duy nhất)
password_hash      NVARCHAR(255)     Hash mật khẩu
full_name          NVARCHAR(255)     Họ và tên
role               NVARCHAR(50)      admin | moderator | user
status             NVARCHAR(50)      active | inactive | banned
is_email_verified  BIT               Đã xác minh email
last_login         DATETIME2         Lần đăng nhập cuối
created_at         DATETIME2         Ngày tạo
updated_at         DATETIME2         Ngày cập nhật cuối
```

**Mặc định:**
- Username: `admin`
- Email: `admin@travelrecommendation.vn`
- Role: `admin`
- Status: `active`

---

### 2️⃣ Categories (Loại Địa Điểm)
```
Cột               Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
category_id (PK)  INT               Mã loại (tự tăng)
category_name     NVARCHAR(100)     Tên loại
category_code     NVARCHAR(50)      Mã loại (duy nhất)
description       NVARCHAR(MAX)     Mô tả chi tiết
icon              NVARCHAR(100)     Icon/class CSS
display_order     INT               Thứ tự hiển thị
is_active         BIT               Hiển thị hay ẩn
created_at        DATETIME2         Ngày tạo
updated_at        DATETIME2         Ngày cập nhật
```

**Dữ Liệu Khởi Tạo:**
1. Nhà Hàng & Quán Ăn (restaurant)
2. Công Viên & Điểm Tham Quan (park)
3. Dịch Vụ Cho Thuê Xe (car_rental)
4. Chợ & Siêu Thị (market)
5. Nhà Thờ & Chùa (religious)
6. Quán Karaoke & Giải Trí (entertainment)
7. Hotel & Khách Sạn (hotel)
8. Quán Cà Phê (coffee)

---

### 3️⃣ Locations (Địa Điểm Du Lịch - Bảng Chính)
```
Cột                Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
location_id (PK)   INT               Mã địa điểm (tự tăng)
location_name      NVARCHAR(255)     Tên địa điểm
category_id (FK)   INT               → Categories
address            NVARCHAR(500)     Địa chỉ đầy đủ
district           NVARCHAR(100)     Phường/Quận
city               NVARCHAR(100)     Thành phố (mặc định HCMC)
postal_code        NVARCHAR(20)      Mã bưu điện
country            NVARCHAR(100)     Quốc gia (mặc định VN)
latitude           FLOAT             Vĩ độ (GPS)
longitude          FLOAT             Kinh độ (GPS)
phone              NVARCHAR(50)      Số điện thoại
website            NVARCHAR(500)     Trang web
email              NVARCHAR(255)     Email liên hệ
description        NVARCHAR(MAX)     Mô tả chi tiết
thumbnail_url      NVARCHAR(500)     URL hình ảnh chính
average_rating     FLOAT             Đánh giá trung bình (0-5)
total_reviews      INT               Tổng số bình luận
is_verified        BIT               Đã xác minh
is_active          BIT               Hoạt động
is_featured        BIT               Nổi bật
position_order     INT               Thứ tự trong danh sách
status             NVARCHAR(50)      pending|approved|rejected|archived
created_at         DATETIME2         Ngày tạo
updated_at         DATETIME2         Ngày cập nhật
```

**Index:**
- IX_Locations_CategoryId (tìm kiếm theo loại)
- IX_Locations_Status (lọc theo trạng thái)
- IX_Locations_Rating (sắp xếp theo đánh giá)

---

### 4️⃣ OperatingHours (Giờ Hoạt Động)
```
Cột                Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
hour_id (PK)       INT               Mã giờ hoạt động
location_id (FK)   INT               → Locations (DELETE CASCADE)
day_of_week        INT               0-6 (Sun-Sat)
day_name           NVARCHAR(20)      Tên thứ (Tiếng Việt)
opening_time       TIME              Giờ mở cửa
closing_time       TIME              Giờ đóng cửa
is_open            BIT               Mở cửa hay không
notes              NVARCHAR(255)     Ghi chú (VD: "Lễ đóng cửa")
created_at         DATETIME2         Ngày tạo
```

**Ví Dụ:**
- Thứ Hai-Chủ Nhật: 11:00 - 23:00
- Có thể cập nhật khác biệt cho mỗi ngày

---

### 5️⃣ Services (Dịch Vụ & Tiện Nghi)
```
Cột             Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
service_id      INT               Mã dịch vụ (tự tăng)
service_name    NVARCHAR(150)     Tên dịch vụ
service_code    NVARCHAR(50)      Mã dịch vụ (duy nhất)
description     NVARCHAR(MAX)     Mô tả chi tiết
service_type    NVARCHAR(50)      amenity | facility | service_option
is_active       BIT               Hoạt động
created_at      DATETIME2         Ngày tạo
```

**Ví Dụ Dữ Liệu:**
- Wi-Fi Miễn Phí (amenity)
- Nhà Vệ Sinh (facility)
- Chỗ Đỗ Xe Miễn Phí (amenity)
- Sân Chơi Trẻ Em (facility)
- Giao Hàng (service_option)
- Mang Đi (service_option)
- Thân Thiện LGBTQ+ (amenity)
- Cho Phép Mang Theo Chó (amenity)

---

### 6️⃣ LocationServices (Bảng Nối - Dịch Vụ tại Địa Điểm)
```
Cột                   Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
location_service_id   INT               Mã (tự tăng)
location_id (FK)      INT               → Locations (DELETE CASCADE)
service_id (FK)       INT               → Services
is_available          BIT               Có sẵn không
notes                 NVARCHAR(255)     Ghi chú
created_at            DATETIME2         Ngày tạo

Constraint:           UNIQUE(location_id, service_id)
```

**Tác Dụng:** Liên kết giữa Locations và Services (Nhiều-Nhiều)

---

### 7️⃣ PriceInfo (Thông Tin Giá)
```
Cột             Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
price_id        INT               Mã giá (tự tăng)
location_id     INT               → Locations (DELETE CASCADE)
price_category  NVARCHAR(100)     budget|moderate|upscale|luxury
min_price       DECIMAL(18,2)     Giá tối thiểu
max_price       DECIMAL(18,2)     Giá tối đa
average_price   DECIMAL(18,2)     Giá trung bình
currency        NVARCHAR(10)      VND (mặc định)
description     NVARCHAR(255)     Mô tả giá
created_at      DATETIME2         Ngày tạo

Constraint:     UNIQUE(location_id, price_category)
```

---

### 8️⃣ Reviews (Bình Luận & Đánh Giá)
```
Cột                Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
review_id          INT               Mã review (tự tăng)
location_id (FK)   INT               → Locations (DELETE CASCADE)
user_id (FK)       INT               → Users (SET NULL)
reviewer_name      NVARCHAR(100)     Tên người bình luận
rating             INT (1-5)         Điểm đánh giá
title              NVARCHAR(255)     Tiêu đề bình luận
review_text        NVARCHAR(MAX)     Nội dung bình luận
helpful_count      INT               Số lượt thích
is_verified_visit  BIT               Đã ghé thăm thực tế
status             NVARCHAR(50)      pending|approved|rejected
created_at         DATETIME2         Ngày tạo
updated_at         DATETIME2         Ngày cập nhật

Index: IX_Reviews_Status (tìm pending)
```

---

### 9️⃣ Images (Hình Ảnh & Thư Viện)
```
Cột               Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
image_id          INT               Mã ảnh (tự tăng)
location_id       INT               → Locations (DELETE CASCADE)
image_url         NVARCHAR(500)     URL hình ảnh
image_title       NVARCHAR(255)     Tiêu đề ảnh
image_description NVARCHAR(MAX)     Mô tả ảnh
image_type        NVARCHAR(50)      thumbnail|gallery|hero
display_order     INT               Thứ tự hiển thị
is_primary        BIT               Ảnh chính hay không
uploaded_by       INT               → Users
created_at        DATETIME2         Ngày upload
```

---

### 🔟 AdminLogs (Lịch Sử Hoạt Động Admin)
```
Cột               Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
log_id            INT               Mã log (tự tăng)
admin_id          INT               → Users (Admin)
action_type       NVARCHAR(100)     create|update|delete|approve|reject|login
entity_type       NVARCHAR(100)     location|review|user|category
entity_id         INT               Mã entity được tác động
description       NVARCHAR(MAX)     Mô tả hành động
old_values        NVARCHAR(MAX)     Giá trị cũ (JSON)
new_values        NVARCHAR(MAX)     Giá trị mới (JSON)
ip_address        NVARCHAR(50)      IP địa chỉ
created_at        DATETIME2         Ngày tạo

Index: IX_AdminLogs_ActionType, IX_AdminLogs_CreatedAt
```

**Tác Dụng:** Theo dõi mọi hoạt động của admin

---

### 1️⃣1️⃣ UserFavorites (Địa Điểm Yêu Thích)
```
Cột               Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
favorite_id       INT               Mã (tự tăng)
user_id           INT               → Users (DELETE CASCADE)
location_id       INT               → Locations (DELETE CASCADE)
note              NVARCHAR(255)     Ghi chú riêng
created_at        DATETIME2         Ngày thêm

Constraint:       UNIQUE(user_id, location_id)
```

---

### 1️⃣2️⃣ Itineraries (Lịch Trình Du Lịch)
```
Cột               Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
itinerary_id      INT               Mã lịch trình (tự tăng)
user_id           INT               → Users (DELETE CASCADE)
title             NVARCHAR(255)     Tên lịch trình
description       NVARCHAR(MAX)     Mô tả
start_date        DATE              Ngày bắt đầu
end_date          DATE              Ngày kết thúc
is_public         BIT               Chia sẻ công khai
created_at        DATETIME2         Ngày tạo
updated_at        DATETIME2         Ngày cập nhật
```

**ItineraryItems** (Địa Điểm trong Lịch Trình)
```
Cột                    Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
item_id                INT               Mã item (tự tăng)
itinerary_id           INT               → Itineraries
location_id            INT               → Locations
day_number             INT               Ngày thứ mấy
visit_order            INT               Thứ tự ghé thăm
visit_start_time       TIME              Giờ bắt đầu
visit_duration_minutes INT               Thời gian lưu lại (phút)
notes                  NVARCHAR(MAX)     Ghi chú
created_at             DATETIME2         Ngày tạo
```

---

### 1️⃣3️⃣ LocationSEO (SEO & Metadata)
```
Cột              Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
seo_id           INT               Mã SEO (tự tăng)
location_id      INT               → Locations (UNIQUE, DELETE CASCADE)
meta_title       NVARCHAR(255)     Tiêu đề SEO (50-60 ký tự)
meta_description NVARCHAR(500)     Mô tả SEO (150-160 ký tự)
meta_keywords    NVARCHAR(500)     Từ khóa (cách nhau bởi dấu phẩy)
slug             NVARCHAR(255)     URL thân thiện (duy nhất)
canonical_url    NVARCHAR(500)     URL chính thức
og_image         NVARCHAR(500)     Ảnh Open Graph
og_description   NVARCHAR(500)     Mô tả Open Graph
created_at       DATETIME2         Ngày tạo
updated_at       DATETIME2         Ngày cập nhật

Index: IX_LocationSEO_Slug
```

---

### 1️⃣4️⃣ AdminSettings (Cấu Hình Hệ Thống)
```
Cột              Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
setting_id       INT               Mã cài đặt (tự tăng)
setting_key      NVARCHAR(100)     Tên setting (duy nhất)
setting_value    NVARCHAR(MAX)     Giá trị
setting_type     NVARCHAR(50)      string|number|boolean|json
description      NVARCHAR(255)     Mô tả
created_at       DATETIME2         Ngày tạo
updated_at       DATETIME2         Ngày cập nhật

Constraint:      UNIQUE(setting_key)
```

**Mặc định:**
- `site_name` = "Du Lịch Gò Vấp"
- `require_review_approval` = true
- `items_per_page` = 20
- `max_upload_file_size` = 5242880 (5MB)

---

### 1️⃣5️⃣ LocationStats (Thống Kê Lượt Xem)
```
Cột                Kiểu Dữ Liệu      Mô Tả
─────────────────────────────────────────────────────────────
stat_id            INT               Mã (tự tăng)
location_id        INT               → Locations (UNIQUE, DELETE CASCADE)
view_count         INT               Số lần xem
favorite_count     INT               Số lần yêu thích
share_count        INT               Số lần chia sẻ
click_phone_count  INT               Số lần click gọi
click_website_count INT              Số lần click website
last_updated       DATETIME2         Cập nhật lần cuối

Constraint:        UNIQUE(location_id)
```

---

## Ghi Chú Thiết Kế

### ✅ Các Nguyên Tắc Thiết Kế Áp Dụng

1. **Chuẩn Hóa (Normalization)**
   - Da Dạng các bảng tế hạn để tránh dữ liệu lặp lại
   - Mỗi bảng có mục đích rõ ràng

2. **Khoá Chính (Primary Key)**
   - Mọi bảng đều có khoá chính `*_id` IDENTITY(1,1)

3. **Khóa Ngoài (Foreign Key)**
   - Áp dụng ON DELETE CASCADE hoặc ON DELETE SET NULL tùy hợp lý

4. **Chỉ Mục (Index)**
   - Tạo chỉ mục cho các cột thường xuyên tìm kiếm/sắp xếp
   - Tên chỉ mục: `IX_TableName_ColumnName`

5. **Ràng Buộc (Constraints)**
   - CHECK constraints cho các giá trị nhất định (role, status)
   - UNIQUE constraints cho các trường không lặp lại (username, email)

6. **Dữ Liệu Thời Gian**
   - `created_at`: Ngày tạo record (DEFAULT SYSUTCDATETIME())
   - `updated_at`: Ngày cập nhật cuối (DEFAULT SYSUTCDATETIME())

### 📊 Các Views (Khung Nhìn)

1. **vw_LocationsWithDetails** - Danh sách địa điểm kèm loại và đánh giá
2. **vw_TopRatedLocations** - Top 50 địa điểm được đánh giá cao nhất
3. **vw_FeaturedLocations** - Các địa điểm nổi bật

### 🔧 Các Stored Procedures (Thủ Tục Lưu Trữ)

1. **sp_ApproveLocation** - Phê duyệt địa điểm (Admin)
2. **sp_UpdateLocationRating** - Cập nhật đánh giá từ reviews
3. **sp_GetLocationStatistics** - Thống kê theo loại
4. **sp_GetPendingReviews** - Lấy bình luận đang chờ duyệt

---

## Quyền Admin

### Người Dùng Admin Mặc Định
```
Username:    admin
Email:       admin@travelrecommendation.vn
Password:    (Kinh nghiệm xác minh hóa)
Role:        admin
Status:      active
```

### Quyền Của Admin
- ✅ Thêm/Sửa/Xóa địa điểm
- ✅ Phê duyệt/Từ chối địa điểm
- ✅ Phê duyệt/Từ chối bình luận
- ✅ Quản lý loại địa điểm
- ✅ Quản lý dịch vụ/tiện nghi
- ✅ Cấu hình hệ thống
- ✅ Xem lịch sử hoạt động
- ✅ Quản lý người dùng
- ✅ Thêm hình ảnh
- ✅ Xem thống kê

---

## Ví Dụ Truy Vấn

### 1️⃣ Tìm 10 nhà hàng được đánh giá cao nhất
```sql
SELECT TOP 10 
    l.location_id, l.location_name, c.category_name,
    l.average_rating, l.total_reviews, l.phone
FROM Locations l
INNER JOIN Categories c ON l.category_id = c.category_id
WHERE c.category_code = 'restaurant' 
  AND l.is_active = 1 
  AND l.status = 'approved'
ORDER BY l.average_rating DESC, l.total_reviews DESC;
```

### 2️⃣ Lấy tất cả bình luận đang chờ duyệt
```sql
EXECUTE sp_GetPendingReviews @PageNumber = 1, @PageSize = 20;
```

### 3️⃣ Cập nhật đánh giá cho một địa điểm
```sql
EXECUTE sp_UpdateLocationRating @LocationId = 1;
```

### 4️⃣ Tìm địa điểm có Wi-Fi miễn phí
```sql
SELECT DISTINCT l.location_id, l.location_name, l.address
FROM Locations l
INNER JOIN LocationServices ls ON l.location_id = ls.location_id
INNER JOIN Services s ON ls.service_id = s.service_id
WHERE s.service_code = 'free_wifi' 
  AND ls.is_available = 1
  AND l.is_active = 1;
```

### 5️⃣ Thêm bình luận mới
```sql
INSERT INTO Reviews 
(location_id, reviewer_name, rating, title, review_text, is_verified_visit, status)
VALUES 
(1, N'Nguyễn Văn A', 5, N'Rất tuyệt vời!', N'Đồ ăn ngon, phục vụ tốt', 1, 'pending');
```

### 6️⃣ Phê duyệt địa điểm mới
```sql
EXECUTE sp_ApproveLocation 
    @LocationId = 1, 
    @AdminId = 1, 
    @Notes = N'Xác minh địa điểm thành công';
```

### 7️⃣ Xem giờ hoạt động của một địa điểm
```sql
SELECT day_name, opening_time, closing_time, notes
FROM OperatingHours
WHERE location_id = 1
ORDER BY day_of_week;
```

### 8️⃣ Lấy thống kê theo loại
```sql
EXECUTE sp_GetLocationStatistics;
```

### 9️⃣ Thêm địa điểm yêu thích
```sql
INSERT INTO UserFavorites (user_id, location_id, note)
VALUES (1, 1, N'Nơi yêu thích nhất để ăn lẩu');
```

### 🔟 Tìm đường đến địa điểm
```sql
SELECT location_id, location_name, address, latitude, longitude
FROM Locations
WHERE location_id = 1;
-- Dùng latitude/longitude cho Google Maps
```

---

## 📝 Lưu Ý Quan Trọng

1. **Bảo Mật**
   - Luôn hash mật khẩu trước khi lưu
   - Sử dụng HTTPS cho tất cả kết nối

2. **Hiệu Suất**
   - Sử dụng pagination (OFFSET/FETCH) cho danh sách lớn
   - Cập nhật statistics theo lịch định kỳ, không real-time

3. **Dữ Liệu**
   - Luôn duyệt bình luận trước khi hiển thị
   - Xác minh địa điểm mới trước khi duyệt
   - Giữ dữ liệu lịch sử (không xóa AdminLogs)

4. **Toàn Vẹn Dữ Liệu**
   - Sử dụng transactions cho các hoạt động phức tạp
   - Backup thường xuyên

---

## 🎯 Kết Luận

Cơ sở dữ liệu này cung cấp:
- ✅ Cấu trúc chuẩn hóa, dễ bảo trì
- ✅ Hiệu suất tối ưu với chỉ mục
- ✅ Toàn vẹn dữ liệu với foreign keys
- ✅ Khả năng mở rộng dễ dàng
- ✅ Quản lý admin toàn diện
- ✅ Hỗ trợ nhiều loại dịch vụ

---

**Tài Liệu Cập Nhật Lần Cuối:** 2026-03-11
**Phiên Bản:** 1.0
**Dành Cho:** SQL Server 2016+ hoặc tương đương
