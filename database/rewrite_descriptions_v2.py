#!/usr/bin/env python
# -*- coding: utf-8 -*-
import pandas as pd
import sys
import random

# Ensure UTF-8 encoding
sys.stdout.reconfigure(encoding='utf-8')

# Read the CSV file
df = pd.read_csv('cleaned_data_updated_2.csv', encoding='utf-8')

# More diverse description patterns for each category
description_patterns = {
    'Chợ': [
        "Chợ {name} thu hút khách hàng với hàng hóa đa dạng, giá cạnh tranh và không khí sôi động.",
        "{name} là điểm mua sắm lý tưởng với sản phẩm tươi sống, giá phải chăng hàng ngày.",
        "Khám phá {name} - chợ truyền thống nơi bạn tìm thấy mọi nhu cầu mua sắm cơ bản.",
        "Chợ {name} nổi bật với đủ loại hàng hóa từ thực phẩm đến nhu yếu phẩm gia đình.",
        "{name} là chợ sôi động với không khí mua bán sinh động và giá thành hợp lý.",
        "Tại {name}, bạn sẽ tìm thấy sự lựa chọn phong phú và giá cạnh tranh nhất.",
        "Chợ {name} mang đến trải nghiệm mua sắm chân thực với sản phẩm chất lượng cao.",
        "{name} là địa chỉ tin cậy cho các nhu cầu mua sắm thường ngày với giá tốt.",
        "Ghé {name} để cảm nhận không gian chợ truyền thống và tìm nguyên liệu tươi.",
        "Chợ {name} mở cửa hàng ngày với hàng hóa phong phú, vệ sinh tốt không khí sôi động.",
    ],
    'Chùa': [
        "Chùa {name} là nơi tâm linh thiêng liêng nơi bạn tìm sự yên bình và thanh tịnh.",
        "{name} mang vẻ đẹp kiến trúc cổ kính với không gian thanh thoát, yên tĩnh.",
        "Ghé thăm {name} để cảm nhận không khí phật pháp và lòng tin yêu thiêng liêng.",
        "Chùa {name} là điểm tu tập linh thiêng với những giá trị tâm linh sâu sắc.",
        "{name} nổi bật với lối kiến trúc đẹp và không khí trang nghiêm, đầy ắp niềm tin.",
        "Tại {name}, bạn có thể tìm thấy sự yên ổn và tinh thần thanh tịnh trong môi trường.",
        "Chùa {name} thu hút nhân viên du khách với vẻ đẹp tâm linh và kiến trúc độc đáo.",
        "{name} là nơi tỳ nạn cho những ai tìm kiếm sự yên bình và sự thành kính.",
        "Ghé {name} để hiểu thêm về phật pháp trong không gian thanh thoát và yên tĩnh.",
        "Chùa {name} mang lại cảm giác thâm kính với không khí tâm linh cao thượng.",
    ],
    'Cà phê': [
        "Cà phê {name} là thiên đường cho tín đồ cà phê với hương vị khoanh lạc.",
        "{name} nổi tiếng với cà phê ngon, không khí ấm cúng và dịch vụ tuyệt vời.",
        "Quán {name} mang lại trải nghiệm cà phê chất lượng cao trong không gian dễ chịu.",
        "Ghé {name} để thưởng thức hương vị cà phê độc đáo và không khí hiện đại.",
        "Cà phê {name} kết hợp giữa truyền thống và hiện đại với hương vị riêng biệt.",
        "Tại {name}, bạn sẽ tìm thấy cà phê ngon cùng không khí yên tĩnh để làm việc.",
        "{name} là quán cà phê được yêu thích với chất lượng cao và phục vụ chu đáo.",
        "Quán {name} cung cấp những tách cà phê tuyệt vời trong không gian thân thiện.",
        "Cà phê {name} hội tụ vị ngon, không khí thoải mái để gặp gỡ bạn bè.",
        "Ghé {name} để thưởng thức hương vị cà phê đỏ Việt Nam đích thực.",
    ],
    'Nhà hàng': [
        "Nhà hàng {name} mang đến những món ăn ngon ngất với chất lượng cao.",
        "{name} là địa chỉ lý tưởng cho những bữa ăn đặc biệt với phục vụ chu đáo.",
        "Quán {name} nổi bật với thực đơn phong phú và hương vị đặc sắc.",
        "Ghé {name} để tận hưởng ẩm thực tuyệt vời trong không khí ấm áp.",
        "Nhà hàng {name} cung cấp các món cơm chiên, súp và các dish đặc biệt.",
        "Tại {name}, bạn sẽ tìm thấy những bữa ăn ngon miệng với giá hợp lý.",
        "{name} là nhà hàng được yêu thích với chất lượng món ăn đảm bảo.",
        "Quán {name} phục vụ ẩm thực đa dạng trong không gian sạch sẽ và thoải mái.",
        "Nhà hàng {name} nổi bật với đội bếp tươi tệ và các nguyên liệu tươi.",
        "Ghé {name} để cảm nhận hương vị ẩm thực đặc trưng vùng đất.",
    ],
    'Quán ăn': [
        "Quán {name} phục vụ những món ăn hấp dẫn với giá phải chăng.",
        "{name} là quán ăn yêu thích của thực khách với chất lượng đảm bảo.",
        "Ghé {name} để thưởng thức ẩm thực địa phương với hương vị tinh tế.",
        "Quán {name} mang đến trải nghiệm ăn uống tuyệt vời với dịch vụ tận tâm.",
        "Tại {name}, bạn tìm thấy những bát cơm ngon cùng canh soup đặc biệt.",
        "{name} nổi bật với menu đa dạng và giá cả hợp lý cho mọi khách.",
        "Quán {name} được yêu thích bởi cộng đồng địa phương với hương vị gốc.",
        "Ghé {name} để dùng bữa nhanh gọn với chất lượng đảm bảo.",
        "Quán {name} cung cấp những món ăn bình dân được mọi người yêu thích.",
        "Tại {name}, mỗi bữa ăn đều là một trải nghiệm ẩm thực độc đáo.",
    ],
    'Khách sạn': [
        "Khách sạn {name} cung cấp phòng ốc thoải mái với tiện nghi hiện đại.",
        "{name} là địa chỉ lưu trú ideal với vị trí thuận tiện và dịch vụ 24/7.",
        "Chọn {name} để có kỳ nghỉ đáng nhớ với những phòng sang trọng.",
        "Khách sạn {name} mang lại sự yên tâm với tiêu chuẩn vệ sinh cao.",
        "Tại {name}, bạn sẽ tận hưởng sự thoải mái và tiện nghi đầy đủ.",
        "{name} là khách sạn tin cậy với phòng sạch sẽ và hỗ trợ khách tuyệt vời.",
        "Ghé {name} để trải nghiệm dịch vụ khách sạn chuyên nghiệp và tận tâm.",
        "Khách sạn {name} nổi bật với view đẹp và tiện nghi cao cấp.",
        "Lưu trú tại {name} để tận hưởng không khí ấm cúng và phục vụ tốt.",
        "Khách sạn {name} là lựa chọn hoàn hảo cho du khách tìm chỗ ở.",
    ],
    'Công viên': [
        "Công viên {name} là nơi lý tưởng để thư giãn với cảnh đẹp thiên nhiên.",
        "{name} cung cấp không khí trong lành và tiện ích giải trí phong phú.",
        "Ghé {name} để cảm nhận sự yên bình giữa không gian xanh mát.",
        "Công viên {name} là điểm tụ tập của cộng đồng với tiện nghi đầy đủ.",
        "Tại {name}, bạn có thể tập thể dục, chơi đùa với gia đình.",
        "{name} nổi bật với cây xanh tươi tốt, nước sạch và không khí sạch.",
        "Công viên {name} mang lại sức khỏe và vui tươi cho người tham quan.",
        "Ghé {name} để tìm sự bình yên giữa thiên nhiên trong lòng thành phố.",
        "Công viên {name} là thiên đường cho những ai yêu thích hoạt động ngoài trời.",
        "Tại {name}, bạn sẽ quên đi mệt mỏi và tìm thấy sự thư thái.",
    ],
    'Trung tâm': [
        "Trung tâm {name} cung cấp dịch vụ chất lượng cao trong môi trường chuyên nghiệp.",
        "{name} là nơi thực hiện các dịch vụ đa ngành với đội ngũ lành nghề.",
        "Ghé {name} để tìm những dịch vụ tốt nhất với giá cạnh tranh.",
        "Trung tâm {name} nổi bật với vị trí thuận tiện và tiện ích hiện đại.",
        "Tại {name}, bạn sẽ nhận được sự hỗ trợ tuyệt vời từ nhân viên.",
        "{name} là trung tâm tin cậy với kinh nghiệm phục vụ lâu năm.",
        "Trung tâm {name} cung cấp giải pháp toàn diện cho nhu cầu của bạn.",
        "Ghé {name} để trải nghiệm dịch vụ chuyên sâu với chất lượng cao.",
        "Trung tâm {name} là địa chỉ được tin tưởng của nhiều khách hàng.",
        "Tại {name}, dịch vụ luôn ưu tiên sự hài lòng khách hàng.",
    ],
    'Siêu thị': [
        "Siêu thị {name} mang đến trải nghiệm mua sắm hiện đại với hàng đa dạng.",
        "{name} là nơi tìm thấy mọi thứ dưới một mái nhà với giá tốt.",
        "Ghé {name} để mua sắm hàng ngày với sản phẩm chất lượng cao.",
        "Siêu thị {name} nổi bật với không gian sạch sẽ và tiên tiến.",
        "Tại {name}, bạn tìm thấy hàng hóa từ thực phẩm đến điện tử.",
        "{name} cung cấp dịch vụ mua sắm tiện lợi với nhân viên hỗ trợ.",
        "Siêu thị {name} là lựa chọn ưa thích với khuyến mãi hấp dẫn.",
        "Ghé {name} để tận hưởng trải nghiệm shopping hiện đại và an toàn.",
        "Siêu thị {name} mang lại sự tiện lợi cho gia đình Việt.",
        "Tại {name}, mọi nhu cầu mua sắm của bạn đều được đáp ứng.",
    ],
}

def get_unique_descriptions(category, names_in_category):
    """Generate unique descriptions for all locations in a category."""
    if category not in description_patterns:
        category = 'Siêu thị'  # fallback
    
    templates = description_patterns[category]
    descriptions_list = []
    template_index = 0
    
    for name in names_in_category:
        # Cycle through templates to avoid repetition
        template = templates[template_index % len(templates)]
        description = template.format(name=name)
        
        # Ensure length is 30-200 characters
        if len(description) > 200:
            description = description[:197] + "..."
        elif len(description) < 30:
            description = description + " Một địa điểm đáng ghé thăm."
        
        descriptions_list.append(description)
        template_index += 1
    
    return descriptions_list

# Group by category and generate unique descriptions
print("Generating unique descriptions for each category...")
new_descriptions_dict = {}

for category in df['danh_muc'].unique():
    category_mask = df['danh_muc'] == category
    names = df[category_mask]['tên'].tolist()
    indices = df[category_mask].index.tolist()
    
    # Generate unique descriptions
    descriptions = get_unique_descriptions(category, names)
    
    # Store with index as key
    for idx, desc in zip(indices, descriptions):
        new_descriptions_dict[idx] = desc
    
    print(f"  {category}: {len(descriptions)} descriptions generated")

# Apply to dataframe in order of index
df['mô_tả'] = df.index.map(new_descriptions_dict)

# Verify the new descriptions
print("\nVerifying new descriptions...")
df['desc_length'] = df['mô_tả'].astype(str).str.len()
print(f"Descriptions < 30 chars: {(df['desc_length'] < 30).sum()}")
print(f"Descriptions 30-200 chars: {((df['desc_length'] >= 30) & (df['desc_length'] <= 200)).sum()}")
print(f"Descriptions > 200 chars: {(df['desc_length'] > 200).sum()}")

# Check for duplicates
print(f"\nTotal unique descriptions: {df['mô_tả'].nunique()} out of {len(df)}")
if df['mô_tả'].nunique() < len(df):
    print("⚠ Warning: Some descriptions are still duplicated")
    # Show duplicates
    duplicates = df[df.duplicated(subset=['mô_tả'], keep=False)]
    print(f"Found {len(duplicates)//2} duplicate pairs")
else:
    print("✓ All descriptions are unique!")

# Show some examples
print("\nSample of new descriptions:")
sample_indices = [0, 50, 100, 150, 200]
for i in sample_indices:
    if i < len(df):
        print(f"\n  {i}. {df.iloc[i]['danh_muc']} | {df.iloc[i]['tên']}")
        print(f"     {df.iloc[i]['mô_tả']}")
        print(f"     Length: {len(df.iloc[i]['mô_tả'])} characters")

# Save the updated dataframe
df_export = df.drop('desc_length', axis=1)
df_export.to_csv('cleaned_data_updated_2.csv', index=False, encoding='utf-8')
print("\n\n✓ File has been saved to cleaned_data_updated_2.csv")
