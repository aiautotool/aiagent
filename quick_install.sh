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
    echo "🍎 macOS detected..."
elif [[ "$OS_TYPE" == "Linux" ]]; then
    if [ -f /etc/debian_version ]; then
        echo "🐧 Ubuntu/Debian detected. Installing dependencies..."
        sudo apt update && sudo apt install -y python3-pip libespeak1 ffmpeg git python3-venv python3-full
    elif [ -f /etc/redhat-release ]; then
        echo "🐧 CentOS/RHEL detected. Installing dependencies..."
        sudo yum install -y python3-pip espeak-ng ffmpeg git
    fi
fi

# 2. Clone/Update repository
if [ -d "$APP_DIR" ]; then
    echo "📂 Directory $APP_DIR already exists. Force updating..."
    cd "$APP_DIR"
    git fetch origin
    git reset --hard origin/main
else
    echo "📥 Cloning repository from GitHub..."
    git clone "$REPO_URL" "$APP_DIR"
    cd "$APP_DIR"
fi

# 3. Setup Virtual Environment (Highly Recommended for PEP 668)
echo "🐍 Setting up Python Virtual Environment..."
# Ensure we clean up old venv if it's broken
rm -rf venv
python3 -m venv venv || { echo "❌ Failed to create venv. Is python3-venv installed?"; exit 1; }

# 4. Setup Permissions
chmod +x *.sh

# 5. Install Python Dependencies
echo "📦 Installing Python dependencies in venv..."
./venv/bin/python3 -m pip install --upgrade pip

# We use --ignore-installed to prevent pip from trying to uninstall system-managed packages like 'blinker'
echo "⚙️ Running isolated pip install..."
./venv/bin/python3 -m pip install --ignore-installed -r requirements.txt

# 6. Khởi tạo config nếu chưa có
if [ ! -f "config.json" ]; then
    echo "⚙️ Khởi tạo file config.json từ mẫu..."
    cp config.json.example config.json
fi

# 7. Install Background Service
echo "⚙️ Thiết lập dịch vụ chạy ngầm..."
./install_service.sh

echo ""
echo "✅ Installation Complete!"
echo "------------------------------------------------"
echo "🌐 Web Interface: http://localhost:15005"
echo "🛠️ Management: ./manage.sh {start|stop|restart|status|logs}"
echo "🔑 Note: Edit ~/aiagent/config.json to enter your API Keys."
echo "------------------------------------------------"
