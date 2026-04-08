import pandas as pd

# Đọc file CSV đã làm sạch
df = pd.read_csv('cleaned_data_updated_2.csv')

# Ghi ra file Excel
df.to_excel('cleaned_data_updated_2_v8.xlsx', index=False)

print("Đã chuyển đổi thành công file cleaned_data_updated_2_v8.xlsx")