#!/bin/bash

# AI Agent API Installation Script for CentOS 7/8/9
# Run as root

set -e

echo "Starting AI Agent API installation..."

# 1. Install Dependencies
echo "Installing Python 3 and Pip..."
yum install -y python3 python3-pip

# 2. Create Application Directory
APP_DIR="/opt/aiagent"
CONF_DIR="/etc/aiagent"

echo "Creating directories..."
mkdir -p $APP_DIR
mkdir -p $CONF_DIR

# 3. Copy Files
echo "Copying application files..."
cp ai_api.py $APP_DIR/
cp ai_agent.py $APP_DIR/
cp requirements.txt $APP_DIR/
cp config.json $CONF_DIR/

# 4. Install Python Requirements
echo "Installing Python requirements..."
pip3 install -r $APP_DIR/requirements.txt

# 5. Setup Systemd Service
echo "Setting up systemd service..."
cp aiagent.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable aiagent
systemctl start aiagent

# 6. Configure Firewall (optional but recommended)
if command -v firewall-cmd > /dev/null; then
    PORT=$(grep -oP '"port":\s*\K\d+' $CONF_DIR/config.json || echo 5005)
    echo "Opening port $PORT in firewall..."
    firewall-cmd --permanent --add-port=${PORT}/tcp
    firewall-cmd --reload
fi

echo "------------------------------------------------"
echo "Installation complete!"
echo "Service status: $(systemctl is-active aiagent)"
echo "Config file: $CONF_DIR/config.json"
echo "Logs: journalctl -u aiagent -f"
echo "------------------------------------------------"
