#!/usr/bin/env python
# -*- coding: utf-8 -*-
import pandas as pd
import os

# Read CSV
df = pd.read_csv('cleaned_data_updated_2_temp.csv', encoding='utf-8')

# Create more comprehensive templates with special considerations
def generate_unique_description(category, name, index_in_category, total_in_category):
    """Generate unique description based on multiple variation factors."""
    
    base_patterns = {
        'Chợ': [
            '{} là chợ truyền thống nơi bạn tìm thấy đủ loại hàng hóa tươi sống.',
            'Khám phá {} - chợ sôi động với giá cạnh tranh hàng ngày.',
            'Tại {}, bạn sẽ tìm được sự lựa chọn phong phú và dịch vụ tốt.',
            '{} mang lại trải nghiệm mua sắm chân thực với sản phẩm chất lượng.',
            'Ghé {} để cảm nhận không khí chợ truyền thống sôi động.',
            '{} là điểm mua sắm ideal với hàng hóa tươi sống giá phải chăng.',
            'Tại {} bạn tìm mọi nhu cầu mua sắm cơ bản từ nhu yếu phẩm.',
            '{} nổi bật với đủ loại hàng và giá cạnh tranh nhất khu vực.',
            'Chợ {} thu hút khách hàng trong không khí sôi động sinh động.',
            '{} là địa chỉ tin cậy cho nhu cầu mua sắm hàng ngày gia đình.',
            'Khám phá {} - chợ tuyệt vời với hàng hóa đa dạng giá tốt.',
            'Tại {} bạn sẽ tìm được sản phẩm chất lượng với giá hợp lý.',
        ],
        'Chùa': [
            '{} là nơi tâm linh thiêng liêng để tìm sự yên bình.',
            '{} mang vẻ đẹp kiến trúc cổ kính với không gian yên tĩnh.',
            'Ghé thăm {} để cảm nhận không khí phật pháp cao thượng.',
            '{} là điểm tu tập linh thiêng với giá trị tâm linh sâu sắc.',
            '{} nổi bật với lối kiến trúc đẹp và không khí trang nghiêm.',
            'Tại {} bạn tìm thấy sự yên ổn và tinh thần thanh tịnh.',
            'Chùa {} thu hút du khách với vẻ đẹp tâm linh kỳ diệu.',
            '{} là nơi tỳ nạn cho ai tìm kiếm sự yên bình tâm linh.',
            'Ghé {} để hiểu thêm về phật pháp trong không khí yên tĩnh.',
            '{} mang cảm giác thâm kính với không khí tâm linh cao.',
            'Tại {} bạn có thể linh thiêng và thanh tịnh tâm hồn.',
            'Chùa {} là nơi tôn giáo sâu sắc cho những tâm hồn xiêu lương.',
        ],
        'Cà phê': [
            '{} là thiên đường cho tín đồ cà phê yêu hương vị tuyệt vời.',
            '{} nổi tiếng với cà phê ngon đầy đủ các loại chất lượng.',
            'Quán {} đem lại trải nghiệm cà phê chất lượng cao dễ chịu.',
            'Ghé {} để thưởng thức hương vị cà phê độc đáo hiện đại.',
            'Cà phê {} kết hợp truyền thống và hiện đại bất ngờ.',
            'Tại {} bạn tìm cà phê ngon không khí yên tĩnh làm việc.',
            '{} là quán cà phê được yêu thích chất lượng phục vụ chu đáo.',
            'Quán {} phục vụ những tách cà phê tuyệt vời không khí.',
            'Cà phê {} hội tụ vị ngon không khí thoải mái gặp bạn.',
            'Ghé {} để thưởng thức cà phê đỏ Việt Nam chân chính.',
            'Tại {} bạn tìm được cà phê ngon không khí yên bình.',
            '{} mang lại trải nghiệm cà phê đặc biệt với môi trường.',
            'Quán {} nổi tiếng với cà phê chuyên sâu phục vụ tuyệt vời.',
            'Ghé {} để tìm cà phê độc đáo trong không gian hiện đại.',
            'Cà phê {} là địa điểm yêu thích tín đồ cà phê chất lượng.',
            'Tại {} bạn có không gian yên tĩnh để thưởng thức cà phê.',
        ],
        'Karaoke': [
            '{} là nơi ideal hát karaoke với bạn bè vui vẻ thích.',
            'Tại {} bạn sẽ có không gian riêng tư giải trí nhạc hay.',
            '{} cung cấp hệ thống âm thanh hiện đại dịch vụ tuyệt vời.',
            'Quán {} nổi bật những phòng hát sang trọng tiện nghi.',
            'Ghé {} để tận hưởng buổi tối karaoke vui nhộn với bạn.',
            'Karaoke {} mang lại niềm vui với bài hát yêu thích.',
            '{} là địa điểm giải trí ideal cho những nhóm bạn.',
            'Tại {} bạn tìm phòng hát sang trọng tiện nghi đầy đủ.',
            'Quán {} phục vụ karaoke chất lượng âm thanh cao nhất.',
            'Ghé {} để có buổi tối karaoke đáng nhớ gia đình.',
            'Karaoke {} cung cấp không gian riêng tư giải trí toàn.',
            'Tại {} bạn sẽ có trải nghiệm karaoke tuyệt vời.',
        ],
        'Nhà thờ': [
            '{} là nơi tâm linh thiêng liêng cho tín ngưỡng.',
            'Tại {} bạn tìm thấy sự yên bình tinh thần cao đẹp.',
            'Nhà thờ {} nổi bật kiến trúc độc đáo ý nghĩa sâu.',
            'Ghé {} để cảm nhận không khí tôn kính linh thiêng thiêng.',
            '{} là nơi tu tập gặp gỡ cộng đồng tín đồ tâm linh.',
            'Tại {} bạn có thể tìm sự bình yên lòng tin ngưỡng.',
            'Nhà thờ {} mang vẻ đẹp kiến trúc cổ kính ý nghĩa.',
            'Ghé {} để hiểu thêm tôn giáo tinh thần cao thượng.',
            '{} cung cấp không gian thiêng liêng hoạt động tâm linh.',
            'Nhà thờ {} là nơi tránh nạn tinh thần mỗi người.',
            'Tại {} bạn tìm được tinh thần cao đẹp tâm linh.',
            '{} là điểm tu tập tín ngưỡng của cộng đồng địa phương.',
        ],
        'Quán ăn': [
            'Quán {} phục vụ những món ăn hấp dẫn giá phải chăng.',
            '{} là quán ăn yêu thích thực khách chất lượng cao.',
            'Ghé {} để thưởng thức ẩm thực địa phương hương vị.',
            'Quán {} mang lại trải nghiệm ăn uống tuyệt vời dịch vụ.',
            'Tại {} bạn tìm những bát cơm ngon canh soup đặc biệt.',
            '{} nổi bật menu đa dạng giá cả hợp lý mọi khách.',
            'Quán {} được yêu thích cộng đồng hương vị gốc.',
            'Ghé {} để dùng bữa nhanh gọn chất lượng đảm bảo.',
            'Quán {} cung cấp những món ăn bình dân yêu thích.',
            'Tại {} mỗi bữa ăn là trải nghiệm ẩm thực độc đáo.',
            '{} là điểm ăn uống được yêu thích của cộng đồng địa phương.',
            'Ghé {} để tìm những hương vị ẩm thực tuyệt vời.',
            'Quán {} nổi tiếng với các món ăn truyền thống ngon.',
            'Tại {} bạn sẽ có bữa ăn ngon miệng với giá tốt.',
            '{} là quán ăn tin cậy với dịch vụ phục vụ tận tâm.',
            'Ghé {} để trải nghiệm ẩm thực đặc trưng vùng đất này.',
        ],
        'Thuê xe': [
            '{} cung cấp dịch vụ thuê xe chất lượng cao giá tốt.',
            'Tại {} bạn tìm được xe đẹp an toàn di chuyển.',
            'Thuê xe tại {} với đội xe hiện đại phục vụ chuyên.',
            'Quán {} nổi bật dịch vụ thuê xe linh hoạt giá cạnh.',
            'Ghé {} để thuê xe du lịch chất lượng cao hỗ trợ.',
            '{} là địa chỉ tin cậy dịch vụ thuê xe địa phương.',
            'Tại {} bạn nhận dịch vụ thuê xe uy tín chuyên sâu.',
            'Thuê xe tại {} với hỗ trợ khách hàng 24/7 giá hợp.',
            'Quán {} cung cấp xe chất lượng chuyến du lịch vui.',
            'Ghé {} để có xe thuê ideal mọi loại chuyến đi.',
            'Dịch vụ {} cung cấp xe sang trọng với giá cạnh tranh.',
            'Tại {} bạn sẽ có xe tốt phục vụ chuyên nghiệp.',
        ],
        'Khách sạn': [
            'Khách sạn {} cung cấp phòng ốc thoải mái tiện nghi.',
            '{} là địa chỉ lưu trú ideal vị trí thuận tiện.',
            'Chọn {} để có kỳ nghỉ đáng nhớ những phòng sang.',
            'Khách sạn {} mang lại sự yên tâm tiêu chuẩn vệ sinh.',
            'Tại {} bạn tận hưởng sự thoải mái tiện nghi tuyệt.',
            '{} là khách sạn tin cậy phòng sạch sẽ hỗ trợ.',
            'Ghé {} để trải nghiệm dịch vụ khách sạn chuyên nghiệp.',
            'Khách sạn {} nổi bật view đẹp tiện ích cao cấp.',
            'Lưu trú tại {} để tận hưởng không khí ấm cúng.',
            'Khách sạn {} là lựa chọn hoàn hảo du khách tìm ở.',
            'Tại {} bạn có phòng đẹp phục vụ 24h chuyên tâm.',
            '{} cung cấp dịch vụ khách sạn công cộng hiện đại.',
            '{} nổi bật với không gian sạch sẽ tiện ích đủ.',
            'Chọn {} để có trải nghiệm lưu trú tuyệt vời.',
            '{} là khách sạn được tin cậy du khách nước ngoài.',
        ],
    }
    
    # Get templates for category
    if category in base_patterns:
        templates = base_patterns[category]
    else:
        # Fallback to Quán ăn templates if category not found
        templates = base_patterns.get('Quán ăn', ['{} là một địa điểm tuyệt vời để ghé thăm.'])
    
    # Use index-based selection to avoid duplicates
    template_index = (index_in_category % len(templates))
    template = templates[template_index]
    
    # Generate description
    description = template.format(name)
    
    # Ensure length constraints
    if len(description) > 200:
        # Truncate carefully
        description = description[:197].rsplit(' ', 1)[0] + '.'
    
    if len(description) < 30:
        # Add more context
        description = description.rstrip('.') + ' - một địa điểm đáng ghé thăm.'
    
    return description

# Group by category and generate descriptions
print("Generating strictly unique descriptions...")
descriptions_list = []
category_indices = {}

for idx, row in df.iterrows():
    category = row['danh_muc']
    name = row['tên']
    
    # Track index within each category
    if category not in category_indices:
        category_indices[category] = 0
    
    # Generate description
    desc = generate_unique_description(category, name, category_indices[category], len(df))
    descriptions_list.append(desc)
    category_indices[category] += 1

# Update dataframe
df['mô_tả'] = descriptions_list

# Verify uniqueness
unique_count = len(set(descriptions_list))
total_count = len(descriptions_list)

print(f"\nResults:")
print(f"✓ Total descriptions: {total_count}")
print(f"✓ Unique descriptions: {unique_count}/{total_count}")

if unique_count == total_count:
    print("✓ ALL DESCRIPTIONS ARE UNIQUE!")
else:
    print(f"⚠ {total_count - unique_count} potential duplicates")

# Check length constraints
lengths = [len(d) for d in descriptions_list]
print(f"\nLength verification:")
print(f"✓ Min length: {min(lengths)} characters")
print(f"✓ Max length: {max(lengths)} characters")
print(f"✓ All >= 30 chars: {all(l >= 30 for l in lengths)}")
print(f"✓ All <= 200 chars: {all(l <= 200 for l in lengths)}")

# Show samples
print(f"\nSample descriptions:")
for i in [0, 50, 100, 150, 200, 300, 400, 500]:
    if i < len(df):
        print(f"\n[{i}] {df.iloc[i]['danh_muc']} | {df.iloc[i]['tên'][:40]}")
        print(f"    {df.iloc[i]['mô_tả']}")

# Save the file and replace original
df.to_csv('cleaned_data_updated_2.csv', index=False, encoding='utf-8')
print("\n✓✓✓ File saved successfully to cleaned_data_updated_2.csv")

# Cleanup temp file
if os.path.exists('cleaned_data_updated_2_temp.csv'):
    os.remove('cleaned_data_updated_2_temp.csv')
    print("✓ Temporary file cleaned up")
