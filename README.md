# AI Agent & TTS Web API

Dự án này cung cấp một API mạnh mẽ để tương tác với các mô hình AI (Gemini, Pollinations, MiMo, LLM7, v.v.) và tích hợp tính năng Chuyển đổi văn bản thành giọng nói (TTS) đa nền tảng chất lượng cao cho Website và Ứng dụng.

---

## 🚀 Cài đặt nhanh (Cách duy nhất)

Dùng một dòng lệnh duy nhất để tự động hóa toàn bộ quy trình: Tải mã nguồn, cài hệ thống phụ thuộc, thiết lập môi trường ảo (venv), cài đặt dịch vụ chạy ngầm và cấu hình Firewall.

**Hỗ trợ**: macOS, Ubuntu (Debian), CentOS (RHEL).

```bash
curl -sSL https://raw.githubusercontent.com/aiautotool/aiagent/main/quick_install.sh | bash
```

---

## 🎯 Tính Năng Chính

### 🧠 AI Generation
- **Đa dạng Model**: Hỗ trợ 5 models AI khác nhau:
  - **Gemini**: Google Gemini 2.0 Flash (Mặc định)
  - **Custom-Gemini**: Gemini với cấu hình server riêng
  - **Pollinations**: Pollinations AI
  - **MiMo**: Xiaomi MiMo
  - **LLM7**: LLM7 Model
- **Smart Fallback**: Tự động chuyển đổi model khác nếu model hiện tại gặp lỗi hoặc rate limit.
- **Load Balancing**: Hỗ trợ nhiều API Key cùng lúc, tự động xoay vòng để tối ưu hiệu suất.
- **Customizable**: Tùy chỉnh `temperature`, `max_tokens` và đặc biệt là `system_prompt` để định hình tính cách AI.

### 🗣️ Text-to-Speech (TTS)
- **Đa Engine**:
  - `native`: Sử dụng giọng offline của hệ điều hành (macOS `say`, Linux/Windows `espeak`/`sapi5`).
  - `gtts`: Sử dụng Google Text-to-Speech (Online) cho giọng tự nhiên hơn.
- **Tùy chỉnh cao**: Điều chỉnh tốc độ (`rate`), âm lượng (`volume`), và chọn giọng đọc (`voice_id`).
- **Base64 Output**: Trả về dữ liệu âm thanh dạng Base64, cực kỳ dễ dàng để phát trên trình duyệt hoặc mobile app mà không cần lưu file.

### 🛠️ Tính Năng Nâng Cao
- **CORS Enabled**: Tích hợp sẵn Cross-Origin Resource Sharing, cho phép gọi API từ bất kỳ domain nào (Frontend, Mobile App).
- **Author Selection**: Thuật toán tự động chọn tác giả phù hợp cho bài viết từ danh sách 46 persona có sẵn.
- **Text Processing**: Các tiện ích xử lý văn bản như `slugify`, `strip_blog_tags` được tích hợp sẵn.
- **Web Interface**: Giao diện test trực quan cho cả TTS và AI Generation.

---

## 🔑 Cấu Hình Nâng Cao

Sau khi cài đặt, bạn **cần** nhập API Key vào `config.json` để các mô hình AI hoạt động tối ưu.

### 1. Cấu hình cơ bản
```bash
nano ~/aiagent/config.json
```

### 2. Thiết lập nhiều Key (Load Balancing)
Bạn có thể cung cấp một danh sách các key, hệ thống sẽ tự động chọn ngẫu nhiên:
```json
{
    "port": 15005,
    "gemini_keys": [
        "AIzaSyD...",
        "AIzaSyE...",
        "AIzaSyF..."
    ],
    "mimo_key": "sk-...",
    "custom_gemini_key": "sk-demo"
}
```

---

## 📚 Tài Liệu API & Hướng Dẫn Sử Dụng

> Xem hướng dẫn chi tiết đầy đủ tại: **[API_GUIDE.md](API_GUIDE.md)**

### 1. Giao diện Web Test
Hệ thống tích hợp sẵn giao diện trực quan để kiểm tra:
- **TTS Test**: [http://localhost:15005/](http://localhost:15005/)
- **AI Test**: [http://localhost:15005/test_generate.html](http://localhost:15005/test_generate.html)
- **Kiểm tra trạng thái**: [http://localhost:15005/](http://localhost:15005/) (GET request)

### 2. API Generate (AI)
- **URL**: `POST /api/generate`
- **Body**:
```json
{
  "prompt": "Viết một bài thơ về Hà Nội",
  "model": "gemini",
  "system_prompt": "Bạn là nhà thơ lãng mạn",
  "temperature": 0.8
}
```

### 3. API TTS (Text-to-Speech)
- **URL**: `POST /api/tts`
- **Body**:
```json
{
  "text": "Xin chào mọi người",
  "engine": "gtts",
  "voice_id": "vi"
}
```

---

## 🛠️ Quản lý dịch vụ

| Lệnh | Mô tả |
| :--- | :--- |
| `./manage.sh start` | Khởi động dịch vụ |
| `./manage.sh stop` | Dừng dịch vụ |
| `./manage.sh restart` | Khởi động lại (cần thiết khi đổi config) |
| `./manage.sh logs` | Xem log thời gian thực |
| `./update.sh` | **Cập nhật lên phiên bản mới nhất** |

---

## ✨ Điểm nổi bật
- **Môi trường biệt lập**: Tự động sử dụng `python3-venv`.
- **An toàn**: Config file nằm trong `.gitignore`, không lo lộ Key khi push code.
- **Tự động mở Port**: Hỗ trợ mở port 15005 trên `ufw`, `firewalld`, `iptables`.
- **Đa nền tảng**: Chạy tốt trên macOS, Linux, Windows (WSL).

---
Phát triển bởi **AIAUTOTOOL**.
