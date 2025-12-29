# AI Agent & TTS Web API

Dự án này cung cấp một API mạnh mẽ để tương tác với các mô hình AI (Gemini, Pollinations, MiMo, v.v.) và tích hợp tính năng Chuyển đổi văn bản thành giọng nói (TTS) đa nền tảng chất lượng cao.

---

## 🚀 Cài đặt nhanh (Cách duy nhất)

Dùng một dòng lệnh duy nhất để tự động hóa toàn bộ quy trình: Tải mã nguồn, cài hệ thống phụ thuộc, thiết lập môi trường ảo (venv), cài đặt dịch vụ chạy ngầm và cấu hình Firewall.

**Hỗ trợ**: macOS, Ubuntu (Debian), CentOS (RHEL).

```bash
curl -sSL https://raw.githubusercontent.com/aiautotool/aiagent/main/quick_install.sh | bash
```

---

## 🔑 Cấu hình API Key (Bắt buộc)

Sau khi cài đặt, bạn **cần** nhập API Key để các mô hình AI hoạt động:

1.  Di chuyển vào thư mục: `cd ~/aiagent`
2.  Mở tệp cấu hình (đã tự động tạo từ mẫu): `nano config.json`
3.  Thay thế các giá trị `YOUR_...` bằng Key thực tế của bạn.
4.  Khởi động lại dịch vụ để áp dụng: `./manage.sh restart`

> **Bảo mật**: Tệp `config.json` đã được đưa vào `.gitignore`. Bạn hoàn toàn yên tâm khi thực hiện các lệnh Git push mà không lo lộ mã bảo mật.

---

## 🛠️ Quản lý dịch vụ

Bạn có thể quản lý trạng thái của API thông qua kịch bản `manage.sh`:

| Lệnh | Mô tả |
| :--- | :--- |
| `./manage.sh start` | Khởi động dịch vụ |
| `./manage.sh stop` | Dừng dịch vụ đang chạy |
| `./manage.sh status` | Kiểm tra trạng thái hoạt động |
| `./manage.sh restart` | Khởi động lại dịch vụ |
| `./manage.sh logs` | Xem nhật ký hệ thống (Log) thời gian thực |
| `./update.sh` | **Cập nhật lên phiên bản mới nhất** |

### 🔄 Cập nhật nhanh bằng một dòng lệnh:
```bash
curl -sSL https://raw.githubusercontent.com/aiautotool/aiagent/main/update.sh | bash
```

---

## 📖 Hướng dẫn sử dụng

### 1. Giao diện Web Test
Hệ thống tích hợp sẵn một giao diện trực quan để bạn kiểm tra tính năng TTS:
- **Địa chỉ**: [http://localhost:15005/](http://localhost:15005/)

### 2. Các Endpoint API chính

#### **Chuyển đổi Văn bản thành Giọng nói (TTS)**
- **Endpoint**: `POST /api/tts`
- **Body mẫu**:
```json
{
  "text": "Chào mừng bạn đến với AI Agent",
  "engine": "gtts",
  "rate": 180,
  "volume": 1.0
}
```
- **Engine**: `native` (Giọng hệ thống - Offline) hoặc `gtts` (Google - Online).

#### **Tương tác AI (Generate)**
- **Endpoint**: `POST /api/generate`
- **Body mẫu**:
```json
{
  "prompt": "Viết một bài giới thiệu về AI",
  "model": "gemini"
}
```

---

## ✨ Điểm nổi bật
- **Môi trường biệt lập**: Tự động sử dụng `python3-venv` để tránh xung đột thư viện hệ thống.
- **Tự động mở Port**: Tự động cấu hình `iptables` / `firewalld` (port 15005).
- **Output Base64**: Trả về dữ liệu âm thanh dưới dạng Base64, dễ dàng tích hợp vào Website hoặc App.
- **Đa nền tảng**: Tương thích tốt với hầu hết các bản phân phối Linux và macOS.

---
Phát triển bởi **AIAUTOTOOL**.
