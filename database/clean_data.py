import pandas as pd
import random
import string

# Đọc file CSV
df = pd.read_csv('merged_data_vi_dedup.csv')

# Xóa các cột được chỉ định
columns_to_drop = ['type_id', 'type_ids', 'types', 'loại', 'id_cid', 'id_dữ_liệu']
df = df.drop(columns=columns_to_drop, errors='ignore')

# Xóa các cột trạng thái/giờ mở và merge cột giờ mở cửa
# Ưu tiên operating_hours_thu_ba; nếu trống lấy giá các ngày lân cận
minutes_cols = [
    'operating_hours_thu_ba',
    'operating_hours_thu_hai',
    'operating_hours_thu_tu',
    'operating_hours_thu_nam',
    'operating_hours_thu_sau',
    'operating_hours_friday',
    'operating_hours_thursday',
    'operating_hours_tuesday',
    'operating_hours_wednesday',
    'operating_hours_saturday',
    'operating_hours_sunday',
    'operating_hours_chu_nhat',
    'operating_hours_monday'
]

# Gộp vào một cột Gio_mo_cua_hang_ngay
# Chú ý: không dùng trạng_thái_mở

def merge_open_hours(row):
    for col in minutes_cols:
        if col in row:
            val = row[col]
            if pd.notna(val) and str(val).strip() != '':
                return str(val).strip()
    return ''

if any(col in df.columns for col in minutes_cols):
    df['Gio_mo_cua_hang_ngay'] = df.apply(merge_open_hours, axis=1)
    df = df.drop(columns=[c for c in minutes_cols if c in df.columns], errors='ignore')

# Xóa cột cụ thể: giờ_mở_cửa, trạng_thái_mở, operating_hours_thu_bay
for col in ['giờ_mở_cửa', 'trạng_thái_mở', 'operating_hours_thu_bay']:
    if col in df.columns:
        df = df.drop(columns=[col], errors='ignore')

# Fill giá trị trống của Gio_mo_cua_hang_ngay từ dòng trên
if 'Gio_mo_cua_hang_ngay' in df.columns:
    df['Gio_mo_cua_hang_ngay'] = df['Gio_mo_cua_hang_ngay'].replace('', pd.NA).ffill().fillna('')

# Xử lý cột xếp_hạng: nếu rỗng thì random từ 3-5
df['xếp_hạng'] = df['xếp_hạng'].apply(lambda x: round(random.uniform(3, 5), 1) if pd.isna(x) or str(x).strip() == '' else x)

# Xử lý cột số_bình_luận: nếu rỗng thì random từ 10-1000
df['số_bình_luận'] = df['số_bình_luận'].apply(lambda x: random.randint(10, 1000) if pd.isna(x) or str(x).strip() == '' else x)

# Xử lý cột giá_trích_xuất theo danh mục
def parse_numeric(val):
    if pd.isna(val):
        return None
    s = str(val).strip().replace(',', '')
    try:
        return float(s)
    except ValueError:
        return None


def hotel_price(val):
    num = parse_numeric(val)
    if num is not None:
        return num * 25000
    return random.randrange(250000, 800001, 50000)


def karaoke_price(val):
    return random.randrange(200000, 1000001, 50000)


def restaurant_price(val):
    options = list(range(50000, 300001, 25000))
    weights = [5 if 100000 <= x <= 200000 else 1 for x in options]
    return random.choices(options, weights=weights, k=1)[0]


def coffee_price(val):
    return random.randrange(30000, 100001, 10000)


def apply_price(row):
    dm = str(row.get('danh_muc', '')).strip().lower()
    orig = row.get('giá_trích_xuất', None)
    if 'chợ' in dm or 'chua' in dm or 'chùa' in dm or 'nhà thờ' in dm:
        return 0
    if 'thuê xe' in dm or 'thue xe' in dm:
        return 100000
    if 'khách sạn' in dm:
        return hotel_price(orig)
    if 'cà phê' in dm or 'ca phê' in dm or 'cafe' in dm:
        return coffee_price(orig)
    if 'karaoke' in dm:
        return karaoke_price(orig)
    if 'quán ăn' in dm or 'quanan' in dm:
        return restaurant_price(orig)
    return orig


df['giá_trích_xuất'] = df.apply(apply_price, axis=1)

# Xử lý cột điện_thoại: nếu rỗng thì random theo định dạng +84 XXX XXX XXX
def generate_phone():
    part1 = ''.join(random.choices(string.digits, k=3))
    part2 = ''.join(random.choices(string.digits, k=3))
    part3 = ''.join(random.choices(string.digits, k=3))
    return f'+84 {part1} {part2} {part3}'

df['điện_thoại'] = df['điện_thoại'].apply(lambda x: generate_phone() if pd.isna(x) or str(x).strip() == '' else x)

# Tạo mô tả tự động cho từng địa điểm, dựa vào tên và không trùng lặp
existing_descriptions = set()

def generate_description(name):
    if pd.isna(name) or str(name).strip() == '':
        base = 'Điểm đến này là một nơi hấp dẫn và nổi bật, thích hợp cho nhiều đối tượng khách hàng.'
    else:
        base = str(name).strip()
    patterns = [
        '{name} là một địa điểm đặc trưng với không gian ấm cúng và dịch vụ chuyên nghiệp, rất phù hợp cho chuyến đi trải nghiệm dài ngày.',
        '{name} thu hút du khách nhờ không khí sinh động, phong cách độc đáo và sự tỉ mỉ trong từng chi tiết dịch vụ.',
        '{name} mang đến trải nghiệm chân thực, hội tụ nét văn hóa địa phương và tiện ích hiện đại cho mọi lứa tuổi.',
        '{name} là lựa chọn lý tưởng khi muốn khám phá ẩm thực, văn hóa và điểm sống động của khu vực, đảm bảo đầy đủ tiện nghi.',
        '{name} nổi bật bởi chất lượng cao, đội ngũ thân thiện và không gian rộng rãi, phù hợp cả gia đình lẫn bạn bè.',
        '{name} đem lại cảm giác thư thái với trang trí tinh tế, thực đơn phong phú và dịch vụ ân cần để bạn ghi nhớ lâu dài.'
    ]
    for i in range(10):
        candidate = random.choice(patterns).format(name=base)
        if candidate not in existing_descriptions:
            existing_descriptions.add(candidate)
            return candidate
        base = f"{base} - phiên bản {i+1}"
    # fallback
    candidate = f"{base} là địa điểm thú vị, độc đáo, đáng thử và đáng nhớ trong trải nghiệm du lịch." 
    existing_descriptions.add(candidate)
    return candidate

# Cập nhật cột mô_tả mọi dòng
if 'tên' in df.columns:
    df['mô_tả'] = df['tên'].apply(lambda x: generate_description(x))
else:
    df['mô_tả'] = df.apply(lambda row: generate_description(row.name), axis=1)

# Ghi file sạch ra
df.to_csv('cleaned_data_updated_2.csv', index=False)

print("Dữ liệu đã được làm sạch và lưu vào cleaned_data_updated_2.csv")