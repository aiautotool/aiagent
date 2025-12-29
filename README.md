# AI Agent & TTS Web API

Dự án này cung cấp một API mạnh mẽ để tương tác với các mô hình AI (Gemini, Pollinations, v.v.) và tích hợp tính năng Chuyển đổi văn bản thành giọng nói (TTS) đa nền tảng.

## 🚀 Cài đặt 

Chạy lệnh duy nhất sau trên Terminal để tự động cài đặt toàn bộ hệ thống (Hỗ trợ **macOS, Ubuntu, CentOS**):

```bash
curl -sSL https://raw.githubusercontent.com/aiautotool/aiagent/main/quick_install.sh | bash
```

---

## 🛠️ Quản lý dịch vụ

Sau khi cài đặt, bạn sử dụng lệnh trong thư mục `~/aiagent` để quản lý:

*   **Khởi động**: `./manage.sh start`
*   **Dừng**: `./manage.sh stop`
*   **Kiểm tra**: `./manage.sh status`
*   **Xem Log**: `./manage.sh logs`

---

## 📖 Cách sử dụng

### 1. Giao diện Web
Truy cập trực tiếp: `http://localhost:5005/`

### 2. API TTS (Ví dụ cURL)
```bash
curl -X POST http://localhost:5005/api/tts \
     -H "Content-Type: application/json" \
     -d '{"text": "Xin chào", "engine": "gtts"}'
```

---

## Tính năng chính
- **AI Generation**: Hỗ trợ nhiều mô hình AI.
- **TTS API**: Hỗ trợ Native (Offline) và Google gTTS (Online).
- **Base64 Output**: Trả về dữ liệu âm thanh trực tiếp để phát trên web.
- **Tự động hóa**: Cài đặt dịch vụ chạy ngầm tự động.

Dự án được phát triển bởi AIAUTOTOOL.
