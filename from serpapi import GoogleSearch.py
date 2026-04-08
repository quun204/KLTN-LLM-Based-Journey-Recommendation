

import requests
import json
import os

API_KEY = "YOUR_API_KEY"

base_url = "https://serpapi.com/search.json"

all_results = []

for start in range(0, 201, 20):

    params = {
        "engine": "google_maps",
        "google_domain": "google.com",
        "hl": "en",
        "ll": "@10.8393345,106.6349363,33940m",
        "q": "Khách sạn gò vấp",
        "type": "search",
        "start": start,
        "api_key": "89bb961c8bd793ffa70cbb36826095436ca4de282a5665968540fed2194e746a"
    }

    print("Đang lấy start =", start)

    response = requests.get(base_url, params=params)
    data = response.json()

    if "local_results" in data:
        all_results.extend(data["local_results"])

print("Tổng địa điểm:", len(all_results))

# tạo thư mục Desktop/test
desktop = os.path.join(os.path.expanduser("~"), "Desktop")
folder = os.path.join(desktop, "test")

os.makedirs(folder, exist_ok=True)

file_path = os.path.join(folder, "hotels_go_vap.json")

with open(file_path, "w", encoding="utf-8") as f:
    json.dump(all_results, f, ensure_ascii=False, indent=2)

print("Đã lưu file tại:", file_path)