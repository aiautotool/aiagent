#!/bin/bash

# One-line Installation Script for AI Agent & TTS API
# Usage: curl -sSL https://raw.githubusercontent.com/aiautotool/aiagent/main/quick_install.sh | bash

set -e

REPO_URL="https://github.com/aiautotool/aiagent.git"
APP_DIR="$HOME/aiagent"

echo "🚀 Starting Quick Installation for AI Agent & TTS API..."

# 1. Clone repository
if [ -d "$APP_DIR" ]; then
    echo "📂 Directory $APP_DIR already exists. Updating..."
    cd "$APP_DIR"
    git pull origin main
else
    echo "📥 Cloning repository..."
    git clone "$REPO_URL" "$APP_DIR"
    cd "$APP_DIR"
fi

# 2. Setup Permissions
chmod +x *.sh

# 3. Install Python Dependencies
echo "📦 Installing Python dependencies..."
pip3 install -r requirements.txt

# 4. Install Background Service
echo "⚙️ Setting up background service..."
./install_service.sh

echo ""
echo "✅ Installation Complete!"
echo "------------------------------------------------"
echo "🌐 Web Interface: http://localhost:5005"
echo "🛠️ Management: ./manage.sh {start|stop|restart|status|logs}"
echo "------------------------------------------------"
