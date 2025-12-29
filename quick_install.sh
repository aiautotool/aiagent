#!/bin/bash

# One-line Installation Script for AI Agent & TTS API
# Usage: curl -sSL https://raw.githubusercontent.com/aiautotool/aiagent/main/quick_install.sh | bash

set -e

REPO_URL="https://github.com/aiautotool/aiagent.git"
APP_DIR="$HOME/aiagent"

echo "🚀 Starting Quick Installation for AI Agent & TTS API..."

# 1. Install System Dependencies based on OS (Ubuntu, CentOS, macOS)
OS_TYPE=$(uname)
echo "🔍 Detecting OS: $OS_TYPE"

if [[ "$OS_TYPE" == "Darwin" ]]; then
    echo "🍎 macOS detected. Ensuring Python3 is available..."
    if ! command -v python3 &> /dev/null; then
        echo "❌ Python3 not found. Please install no via Homebrew or official installer."
        exit 1
    fi
elif [[ "$OS_TYPE" == "Linux" ]]; then
    if [ -f /etc/debian_version ]; then
        echo "🐧 Ubuntu/Debian detected. Installing dependencies..."
        sudo apt update && sudo apt install -y python3-pip libespeak1 ffmpeg git python3-full
    elif [ -f /etc/redhat-release ]; then
        echo "🐧 CentOS/RHEL detected. Installing dependencies..."
        sudo yum install -y python3-pip espeak-ng ffmpeg git
    else
        echo "⚠️ Unknown Linux distribution. Proceeding anyway..."
    fi
fi

# 2. Clone/Update repository
if [ -d "$APP_DIR" ]; then
    echo "📂 Directory $APP_DIR đã tồn tại. Đang cập nhật..."
    cd "$APP_DIR"
    git fetch origin
    git reset --hard origin/main
else
    echo "📥 Đang tải mã nguồn từ GitHub..."
    git clone "$REPO_URL" "$APP_DIR"
    cd "$APP_DIR"
fi

# 3. Setup Permissions
chmod +x *.sh

# 4. Install Python Dependencies
echo "📦 Installing Python dependencies..."
# Detect if we need --break-system-packages (PEP 668)
PIP_FLAGS=""
if pip3 install --help 2>&1 | grep -q "break-system-packages"; then
    PIP_FLAGS="--break-system-packages"
    echo "💡 Using --break-system-packages to override environment management."
fi

# Try installing
pip3 install $PIP_FLAGS -r requirements.txt || python3 -m pip install $PIP_FLAGS -r requirements.txt

# 5. Khởi tạo config nếu chưa có
if [ ! -f "config.json" ]; then
    echo "⚙️ Khởi tạo file config.json từ mẫu..."
    cp config.json.example config.json
fi

# 6. Install Background Service
echo "⚙️ Thiết lập dịch vụ chạy ngầm..."
./install_service.sh

echo ""
echo "✅ Installation Complete!"
echo "------------------------------------------------"
echo "🌐 Web Interface: http://localhost:15005"
echo "🛠️ Management: ./manage.sh {start|stop|restart|status|logs}"
echo "🔑 Lưu ý: Hãy sửa file ~/aiagent/config.json để nhập API Key của bạn."
echo "------------------------------------------------"
