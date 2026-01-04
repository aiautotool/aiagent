# Hướng Dẫn Sử Dụng Smart Agent API

Tài liệu này hướng dẫn cách sử dụng endpoint `/v1/agent/smart` của Antigravity Proxy. Đây là API thông minh có khả năng:
1.  **Tự động suy luận (ReAct)**: Sử dụng các công cụ như tìm kiếm Google, lấy thời gian, truy cập URL.
2.  **Xử lý song song (Parallel Mode)**: Tự động phát hiện yêu cầu vừa viết bài vừa tạo ảnh để thực hiện đồng thời, giảm thiểu thời gian chờ đợi.
3.  **Tích hợp Image Generation**: Tạo ảnh minh họa và tự động chèn vào nội dung bài viết.

---

## 1. Thông tin Endpoint

*   **URL**: `http://localhost:5007/v1/agent/smart`
*   **Method**: `POST`
*   **Content-Type**: `application/json`

---

## 2. Cấu trúc Request (Payload)

Body của request là một JSON object với các trường sau:

| Trường | Kiểu dữ liệu | Bắt buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `prompt` | `string` | Có | Câu lệnh hoặc yêu cầu của người dùng. |
| `messages` | `array` | Không | Lịch sử hội thoại (dành cho chat bot). |
| `model` | `string` | Không | Model chỉ định (mặc định sẽ tự động chọn `gemini-3-flash`). |

### Ví dụ JSON:

```json
{
  "prompt": "Viết một bài thơ ngắn về biển cả và vẽ một bức tranh minh họa sóng biển.",
  "messages": []
}
```

---

## 3. Các Chế Độ Hoạt Động (Modes)

API sẽ tự động phân tích `prompt` để chọn chế độ xử lý phù hợp.

### A. Chế độ Song Song (Parallel Mode) - MỚI 🚀
Sẽ được kích hoạt khi prompt chứa từ khóa của cả 2 hành động:
*   **Viết/Nội dung**: "viết", "soạn thảo", "thơ", "bài viết", "blog",...
*   **Vẽ/Hình ảnh**: "vẽ", "tạo ảnh", "minh họa", "hình ảnh",...

**Cơ chế hoạt động:**
*   Hệ thống khởi chạy 2 luồng (thread) riềng biệt: một luồng viết nội dung và một luồng tạo ảnh.
*   Ảnh sau khi tạo xong sẽ được tự động chèn vào nội dung tại vị trí phù hợp (thay thế placeholder `[PENDING_IMAGE_1]`).

### B. Chế độ Tuần Tự (Serial / ReAct)
Sử dụng cho các tác vụ thông thường:
*   Hỏi đáp kiến thức.
*   Tìm kiếm thông tin (Google Search).
*   Truy cập và tóm tắt nội dung trang web.
*   Chỉ tạo ảnh đơn lẻ.

---

## 4. Cấu trúc Response

Response trả về là JSON object:

```json
{
  "result": "Nội dung trả lời từ AI (đã bao gồm markdown ảnh nếu có)...",
  "model": "gemini-3-flash",
  "search_used": false,
  "mode": "parallel" 
}
```

*   `result`: Nội dung chính (Markdown).
*   `model`: Tên model đã thực hiện tác vụ chính.
*   `search_used`: `true` nếu agent đã thực hiện tìm kiếm Google.
*   `mode`: `parallel` nếu chạy song song, hoặc không có (cho chế độ thường).
*   `thought_log`: (Có thể xuất hiện trong nội dung `result`) Nhật ký suy nghĩ của AI.

---

## 5. Ví dụ Code Python

```python
import requests
import json

url = "http://localhost:5007/v1/agent/smart"

# Prompt kích hoạt Parallel Mode
prompt = "Viết một bài blog ngắn về du lịch Đà Lạt và vẽ ảnh minh họa Hồ Xuân Hương."

payload = {
    "prompt": prompt
}

print(f"Đang gửi request: {prompt}...")
try:
    response = requests.post(url, json=payload, timeout=120)
    
    if response.status_code == 200:
        data = response.json()
        print("\n=== KẾT QUẢ ===")
        print(data['result'])
        print(f"\nMode: {data.get('mode', 'serial')}")
    else:
        print(f"Lỗi: {response.text}")

except Exception as e:
    print(f"Exception: {e}")
```

---

## 6. Lưu ý Troubleshooting

*   **Lỗi 403/Permission**: Đôi khi model `gemini-3-pro-image` yêu cầu quyền hạn cao. Hệ thống đã có cơ chế tự động bỏ qua các tài khoản không hợp lệ (Mock Project ID) để giảm thiểu lỗi này.
*   **Timeout**: Tác vụ tạo ảnh có thể mất 10-20 giây. Hãy set timeout cho client của bạn ít nhất là **60s**.
