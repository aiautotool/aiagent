#!/bin/bash

# Script to install AI Agent as a background service
# Supports both macOS and Linux (Systemd)

OS_TYPE=$(uname)
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_EXEC="$APP_DIR/venv/bin/python3"

# Fallback to system python if venv doesn't exist
if [ ! -f "$PYTHON_EXEC" ]; then
    PYTHON_EXEC=$(which python3)
fi

if [[ "$OS_TYPE" == "Darwin" ]]; then
    echo "🍎 Installing service on macOS..."
    PLIST_PATH="$HOME/Library/LaunchAgents/com.aiautotool.aiagent.plist"
    
    # Create or update plist with correct paths
    cat <<EOF > "$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.aiautotool.aiagent</string>
    <key>ProgramArguments</key>
    <array>
        <string>$PYTHON_EXEC</string>
        <string>$APP_DIR/ai_api.py</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>WorkingDirectory</key>
    <string>$APP_DIR</string>
    <key>StandardOutPath</key>
    <string>$APP_DIR/ai_api.log</string>
    <key>StandardErrorPath</key>
    <string>$APP_DIR/ai_api.log</string>
</dict>
</plist>
EOF
    
    # Reload the service
    launchctl unload "$PLIST_PATH" 2>/dev/null
    launchctl load "$PLIST_PATH"
    
    echo "✅ Service installed and started on macOS."
    
elif [[ "$OS_TYPE" == "Linux" ]]; then
    echo "🐧 Installing service on Linux..."
    
    # Create systemd service file dynamically
    SERVICE_FILE="/etc/systemd/system/aiagent.service"
    sudo bash -c "cat <<EOF > $SERVICE_FILE
[Unit]
Description=AI Agent Web API Service
After=network.target

[Service]
User=$(whoami)
WorkingDirectory=$APP_DIR
ExecStart=$PYTHON_EXEC $APP_DIR/ai_api.py
Restart=always
Environment=PYTHONPATH=$APP_DIR

[Install]
WantedBy=multi-user.target
EOF"
    
    sudo systemctl daemon-reload
    sudo systemctl enable aiagent
    sudo systemctl restart aiagent
    
    # Open Port 15005 in Firewall
    echo "🛡️ Opening port 15005 in Firewall..."
    if command -v firewall-cmd > /dev/null; then
        sudo firewall-cmd --permanent --add-port=15005/tcp
        sudo firewall-cmd --reload
    fi
    if command -v iptables > /dev/null; then
        sudo iptables -I INPUT -p tcp --dport 15005 -j ACCEPT
        # Save if possible
        if [ -f /etc/sysconfig/iptables ]; then sudo service iptables save; fi
    fi

    echo "✅ Service installed and started on Linux."
else
    echo "❌ Unsupported OS: $OS_TYPE"
    exit 1
fi
