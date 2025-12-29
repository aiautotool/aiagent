#!/bin/bash

# Update script for AI Agent & TTS API
# This script pulls the latest changes and restarts the service safely.

set -e

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$APP_DIR"

echo "🔄 Đang kiểm tra bản cập nhật mới nhất từ GitHub..."

# 1. Fetch and Reset to avoid local conflicts
git fetch origin
git reset --hard origin/main

# 2. Re-apply permissions
chmod +x *.sh

# 3. Update dependencies in venv if it exists
if [ -d "venv" ]; then
    echo "📦 Đang cập nhật thư viện Python (venv)..."
    ./venv/bin/python3 -m pip install --upgrade pip
    ./venv/bin/python3 -m pip install --ignore-installed -r requirements.txt
else
    echo "📦 Đang cập nhật thư viện Python (System)..."
    pip3 install --break-system-packages -r requirements.txt || pip3 install -r requirements.txt
fi

# 4. Restart the service
echo "⚙️ Đang khởi động lại dịch vụ..."
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    ./install_service.sh
    ./manage.sh restart
elif [[ "$(uname)" == "Linux" ]]; then
    # Linux (Systemd)
    sudo systemctl restart aiagent
fi

echo ""
echo "✅ Cập nhật hoàn tất!"
echo "------------------------------------------------"
echo "🌐 Trạng thái: $(./manage.sh status)"
echo "------------------------------------------------"
