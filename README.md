# AI Agent & TTS Web API

Dự án này cung cấp một API mạnh mẽ để tương tác với các mô hình AI (Gemini, Pollinations, v.v.) và tích hợp tính năng Chuyển đổi văn bản thành giọng nói (TTS) đa nền tảng.

## Tính năng chính
- **AI Generation**: Hỗ trợ nhiều mô hình AI khác nhau qua một giao diện API duy nhất.
- **TTS API**: Hỗ trợ 2 công cụ (Engine):
    - **Native/pyttsx3**: Sử dụng thư viện hệ thống (Offline), hỗ trợ tốt macOS và Linux.
    - **Google gTTS**: Sử dụng giọng đọc của Google (Online), giọng đọc tự nhiên.
- **Giao diện Web Test**: Tích hợp sẵn giao diện trực quan tại đường dẫn gốc (`/`) để thử nghiệm nhanh.
- **Base64 Output**: Trả về dữ liệu âm thanh dưới dạng chuỗi Base64 (M4A/MP3/WAV) để phát trực tiếp trên Web.

---

## Hướng dẫn cài đặt trên Linux (Ubuntu/Debian)

### 1. Cập nhật hệ thống và cài đặt phụ thuộc
```bash
sudo apt update
sudo apt install python3-pip python3-dev espeak ffmpeg libespeak1 -y
```
*Lưu ý: `espeak` là thư viện cần thiết để `pyttsx3` hoạt động offline trên Linux.*

### 2. Tải mã nguồn và cài đặt thư viện Python
```bash
git clone https://github.com/aiautotool/aiagent.git
cd aiagent
pip3 install -r requirements.txt
```

### 3. Cấu hình (Tùy chọn)
Chỉnh sửa file `config.json` để thay đổi cổng (mặc định là 5005) hoặc các API Key của bạn.

### 4. Chạy API Server
```bash
python3 ai_api.py
```

---

## Cách sử dụng

### 1. Truy cập giao diện Web
Mở trình duyệt và truy cập: `http://your-ip:5005/`

### 2. Sử dụng API qua cURL (Ví dụ TTS)

**Chuyển đổi văn bản thành giọng nói:**
```bash
curl -X POST http://localhost:5005/api/tts \
     -H "Content-Type: application/json" \
     -d '{
       "text": "Xin chào, tôi là trợ lý AI.",
       "engine": "gtts"
     }'
```

**Lấy danh sách giọng đọc của hệ thống:**
```bash
curl -X GET http://localhost:5005/api/voices
```

### 3. Tham số API TTS
| Tham số | Kiểu | Mô tả |
| :--- | :--- | :--- |
| `text` | string | (Bắt buộc) Văn bản cần đọc. |
| `engine` | string | `native` (mặc định) hoặc `gtts`. |
| `voice_id` | string | ID giọng đọc (chỉ dùng cho `native`). |
| `rate` | int | Tốc độ đọc (ví dụ: 150 - 200). |
| `volume` | float | Âm lượng (0.0 đến 1.0). |

---

## Triển khai như một Dịch vụ (Systemd)
Để API luôn chạy ngầm và tự khởi động cùng hệ thống:

1. Chỉnh sửa file `aiagent.service` cho đúng đường dẫn `WorkingDirectory`.
2. Sao chép vào thư mục hệ thống:
```bash
sudo cp aiagent.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable aiagent
sudo systemctl start aiagent
```

## Giấy phép
Dự án được phát triển bởi AIAUTOTOOL.
