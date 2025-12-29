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
        echo "❌ Python3 not found. Please install it via Homebrew or official installer."
        exit 1
    fi
elif [[ "$OS_TYPE" == "Linux" ]]; then
    if [ -f /etc/debian_version ]; then
        echo "🐧 Ubuntu/Debian detected. Installing dependencies..."
        sudo apt update && sudo apt install -y python3-pip libespeak1 ffmpeg git
    elif [ -f /etc/redhat-release ]; then
        echo "🐧 CentOS/RHEL detected. Installing dependencies..."
        sudo yum install -y python3-pip espeak-ng ffmpeg git
    else
        echo "⚠️ Unknown Linux distribution. Proceeding anyway..."
    fi
fi

# 2. Clone/Update repository
if [ -d "$APP_DIR" ]; then
    echo "📂 Directory $APP_DIR already exists. Updating..."
    cd "$APP_DIR"
    git pull origin main
else
    echo "📥 Cloning repository..."
    git clone "$REPO_URL" "$APP_DIR"
    cd "$APP_DIR"
fi

# 3. Setup Permissions
chmod +x *.sh

# 4. Install Python Dependencies
echo "📦 Installing Python dependencies..."
pip3 install -r requirements.txt

# 5. Install Background Service
echo "⚙️ Setting up background service..."
./install_service.sh

echo ""
echo "✅ Installation Complete!"
echo "------------------------------------------------"
echo "🌐 Web Interface: http://localhost:15005"
echo "🛠️ Management: ./manage.sh {start|stop|restart|status|logs}"
echo "------------------------------------------------"
