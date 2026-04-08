#!/usr/bin/env python
# -*- coding: utf-8 -*-
import pandas as pd
import sys

# Ensure UTF-8 encoding
sys.stdout.reconfigure(encoding='utf-8')

# Read the CSV file
df = pd.read_csv('cleaned_data_updated_2.csv', encoding='utf-8')

# Templates for descriptions based on categories
description_templates = {
    'Chợ': [
        "Chợ {name} là điểm mua sắm sôi động với hàng hóa đa dạng, giá cạnh tranh và không khí sinh động.",
        "Ghé thăm {name} để trải nghiệm mua sắm truyền thống với đủ loại hàng hóa tươi sống hàng ngày.",
        "Chợ {name} nổi bật với không gian rộng rãi, vệ sinh sạch sẽ và sản phẩm chất lượng với giá tốt.",
        "{name} là chợ đầy sức sống nơi du khách can tìm mọi thứ cần thiết từ thực phẩm tươi sống đến nhu yếu phẩm.",
        "Khám phá {name} - một chợ trưởng thành với đầy đủ tiện nghi hiện đại và sản phẩm chất lượng cao.",
    ],
    'Chùa': [
        "Chùa {name} là điểm tờ mơ thiêng liêng với kiến trúc cổ kính, không khí thanh bình và yên tĩnh.",
        "Ghé thăm {name} để cảm nhận không gian tâm linh, kiến trúc đẹp và dòng người khả kính.",
        "{name} là chùa linh thiêng nơi bạn có thể tìm thấy sự yên bình, tìm hiểu phật pháp.",
        "Chùa {name} mang vẻ đẹp truyền thống, trang nghiêm trong bầu không khí tâm linh thanh tịnh.",
        "Nơi tu tập gắn liền với lịch sử, {name} là chùa đầy ắp niềm tin và sự thành kính.",
    ],
    'Cà phê': [
        "Cà phê {name} là thiên đường cho những người yêu thích cà phê chất lượng với không khí ấm cúng.",
        "Quán {name} nổi tiếng với cà phê thơm ngon, không gian hiện đại và dịch vụ tuyệt vời.",
        "Ghé {name} để thưởng thức hương vị cà phê đỏ Việt Nam trong không khí thoải mái.",
        "{name} là nơi lý tưởng cho các tín đồ cà phê muốn tìm chất lượng cao và trải nghiệm độc đáo.",
        "Cà phê {name} kết hợp hương vị truyền thống và hiện đại, phục vụ trong không gian tinh tế.",
    ],
    'Nhà hàng': [
        "Nhà hàng {name} mang đến những món ăn ngon miệng với chất lượng cao và dịch vụ tuyệt vời.",
        "Quán {name} là địa chỉ không thể bỏ qua cho những ai yêu thích ẩm thực với giá tốt.",
        "Ghé thăm {name} để thưởng thức những dish tinh tế với hương vị đặc biệt.",
        "{name} nổi bật với thực đơn phong phú, không khí ấm cúng và đội phục vụ chuyên nghiệp.",
        "Nhà hàng {name} là lựa chọn hoàn hảo cho những bữa ăn đặc biệt với chất lượng cao.",
    ],
    'Quán ăn': [
        "Quán {name} phục vụ những món ăn đặc biệt, giá phải chăng và được yêu thích bởi nhiều thực khách.",
        "Ghé {name} để tìm đủ hương vị ẩm thực tuyệt vời trong không gian ấm áp.",
        "{name} là quán ăn nổi tiếng với chất lượng món ăn cao, giá cả hợp lý.",
        "Quán {name} mang đến trải nghiệm ẩm thực độc đáo với phục vụ nhanh chóng, tận tình.",
        "Tìm thấy những bất ngờ ẩm thực tại {name}, quán ăn được yêu thích của cộng đồng địa phương.",
    ],
    'Khách sạn': [
        "Khách sạn {name} cung cấp các dịch vụ lưu trú tuyệt vời với tiện nghi hiện đại.",
        "Chọn {name} để có một kỳ nghỉ đáng nhớ với phòng ốc thoải mái và dịch vụ tận tâm.",
        "{name} là khách sạn lý tưởng với vị trí thuận tiện, phòng sạch sẽ và tiện nghi đầy đủ.",
        "Khách sạn {name} mang đến sự thoải mái, an toàn và dịch vụ hỗ trợ 24/7 cho du khách.",
        "Lưu trú tại {name} để tận hưởng những tiện nghi cao cấp và không khí ấm cúng.",
    ],
    'Công viên': [
        "Công viên {name} là nơi lý tưởng để thư giãn, tập thể dục và chơi đùa với gia đình.",
        "Ghé thăm {name} để cảm nhận cảnh đẹp thiên nhiên, không khí trong lành.",
        "{name} có những tiện nghi đằng cấp, cây xanh tươi tốt và không gian rộng rãi.",
        "Công viên {name} là điểm tụ tập của cộng đồng dân cư, mang lại sự sống động.",
        "Tìm sự bình yên tại {name}, nơi có không khí xanh mát và tiện ích giải trí.",
    ],
    'Trung tâm': [
        "Trung tâm {name} là nơi cung cấp dịch vụ chất lượng cao với các văn phòng hiện đại.",
        "Ghé {name} để tìm được những dịch vụ tốt nhất trong lĩnh vực kinh doanh, giáo dục.",
        "{name} nổi bật với vị trí thuận tiện, tiện ích đầy đủ và không khí chuyên nghiệp.",
        "Trung tâm {name} là điểm đến tin cậy cho các hoạt động thương mại, sự kiện.",
        "Lựa chọn {name} để trải nghiệm dịch vụ chuyên sâu và môi trường làm việc tuyệt vời.",
    ],
    'Siêu thị': [
        "Siêu thị {name} mang đến trải nghiệm mua sắm hiện đại với hàng hóa đa dạng.",
        "Ghé {name} để tìm mọi thứ cần thiết dưới một mái nhà với giá cạnh tranh.",
        "{name} nổi tiếng với không gian sạch sẽ, sản phẩm chất lượng cao và dịch vụ tốt.",
        "Siêu thị {name} là lựa chọn hoàn hảo cho mua sắm hàng ngày với tiện ích đầy đủ.",
        "Mua sắm tại {name} với những sản phẩm đa dạng, giá tốt và không khí shoppingdễ chịu.",
    ],
    'Khác': [
        "{name} là một địa điểm thú vị với những đặc điểm và dịch vụ riêng biệt.",
        "Khám phá {name} để có những trải nghiệm mới lạ và đáng nhớ.",
        "{name} mang đến cho bạn những điều bất ngờ với tính chất độc đáo.",
        "Ghé thăm {name} để cảm nhận không khí đặc biệt và nét văn hóa địa phương.",
        "{name} là nơi không thể bỏ qua khi bạn muốn khám phá cái mới.",
    ]
}

def generate_description(category, name, templates_dict):
    """Generate a description based on category and name."""
    import random
    
    # Get templates for this category, or use 'Khác' as fallback
    if category in templates_dict:
        templates = templates_dict[category]
    else:
        templates = templates_dict.get('Khác', templates_dict['Khác'])
    
    # Randomly select a template
    template = random.choice(templates)
    
    # Format the template with the place name
    description = template.format(name=name)
    
    # Ensure it's between 30 and 200 characters
    if len(description) > 200:
        # Truncate if too long
        description = description[:197] + "..."
    elif len(description) < 30:
        # This shouldn't happen, but just in case
        description = description + " Một địa điểm đáng ghé thăm."
    
    return description

# Apply the function to all rows
print("Generating new descriptions...")
new_descriptions = []
for idx, row in df.iterrows():
    category = row['danh_muc']
    name = row['tên']
    new_desc = generate_description(category, name, description_templates)
    new_descriptions.append(new_desc)
    if (idx + 1) % 100 == 0:
        print(f"  Processed {idx + 1}/{len(df)} rows")

# Update the dataframe
df['mô_tả'] = new_descriptions

# Verify the new descriptions
print("\nVerifying new descriptions...")
df['desc_length'] = df['mô_tả'].astype(str).str.len()
print(f"Descriptions < 30 chars: {(df['desc_length'] < 30).sum()}")
print(f"Descriptions 30-200 chars: {((df['desc_length'] >= 30) & (df['desc_length'] <= 200)).sum()}")
print(f"Descriptions > 200 chars: {(df['desc_length'] > 200).sum()}")

# Show some examples
print("\nSample of new descriptions:")
for i in range(5):
    print(f"\nCategory: {df.iloc[i]['danh_muc']}")
    print(f"Name: {df.iloc[i]['tên']}")
    print(f"Description: {df.iloc[i]['mô_tả']}")
    print(f"Length: {len(df.iloc[i]['mô_tả'])} characters")

# Save the updated dataframe
df_export = df.drop('desc_length', axis=1)
df_export.to_csv('cleaned_data_updated_2.csv', index=False, encoding='utf-8')
print("\n\nFile has been saved to cleaned_data_updated_2.csv")
