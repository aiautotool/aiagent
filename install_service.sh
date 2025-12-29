#!/bin/bash

# Script to install AI Agent as a background service
# Supports both macOS and Linux (Systemd)

OS_TYPE=$(uname)

if [[ "$OS_TYPE" == "Darwin" ]]; then
    echo "Installing service on macOS..."
    PLIST_PATH="$HOME/Library/LaunchAgents/com.aiautotool.aiagent.plist"
    cp com.aiautotool.aiagent.plist "$PLIST_PATH"
    
    # Reload the service
    launchctl unload "$PLIST_PATH" 2>/dev/null
    launchctl load "$PLIST_PATH"
    
    echo "Service installed and started on macOS."
    echo "Use 'launchctl list | grep aiagent' to check status."
    
elif [[ "$OS_TYPE" == "Linux" ]]; then
    echo "Installing service on Linux..."
    # Ensure dependencies for TTS
    if [ -f /etc/debian_version ]; then
        sudo apt update && sudo apt install -y python3-pip libespeak1 ffmpeg
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y python3-pip espeak-ng ffmpeg
    fi
    
    sudo cp aiagent.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable aiagent
    sudo systemctl start aiagent
    echo "Service installed and started on Linux."
    echo "Use 'sudo systemctl status aiagent' to check status."
else
    echo "Unsupported OS: $OS_TYPE"
    exit 1
fi
