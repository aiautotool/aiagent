# AI Agent & TTS Web API

Dự án này cung cấp một API mạnh mẽ để tương tác với các mô hình AI (Gemini, Pollinations, v.v.) và tích hợp tính năng Chuyển đổi văn bản thành giọng nói (TTS) đa nền tảng.

## 🚀 Cài đặt 

Chạy lệnh duy nhất sau trên Terminal để tự động cài đặt toàn bộ hệ thống (Hỗ trợ **macOS, Ubuntu, CentOS**):

```bash
curl -sSL https://raw.githubusercontent.com/aiautotool/aiagent/main/quick_install.sh | bash
```

---

## 🔑 Cấu hình API Key

Để AI hoạt động, bạn cần cấu hình các API Key trong file `config.json`:

1.  Sao chép file mẫu: `cp config.json.example config.json`
2.  Mở `config.json` và thay thế các giá trị `YOUR_...` bằng key thật của bạn.
3.  Lưu file và khởi động lại dịch vụ: `./manage.sh restart`

*Lưu ý: File `config.json` đã được đưa vào `.gitignore` để tránh rò rỉ mã bảo mật.*

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
Truy cập trực tiếp: `http://localhost:15005/`

### 2. API TTS (Ví dụ cURL)
```bash
curl -X POST http://localhost:15005/api/tts \
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
