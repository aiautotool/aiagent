#!/bin/bash

# Management script for AI Agent API on macOS
APP_DIR="/Users/vkct/aiagent"
API_SCRIPT="ai_api.py"
LOG_FILE="ai_api.log"
PID_FILE="ai_api.pid"

case "$1" in
    start)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "Service is already running (PID: $(cat "$PID_FILE"))."
        else
            echo "Starting AI Agent API..."
            nohup python3 "$APP_DIR/$API_SCRIPT" > "$APP_DIR/$LOG_FILE" 2>&1 &
            echo $! > "$PID_FILE"
            echo "Service started (PID: $(cat "$PID_FILE"))."
        fi
        ;;
    stop)
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            echo "Stopping AI Agent API (PID: $PID)..."
            kill $PID && rm "$PID_FILE"
            # Also pkill just to be sure
            pkill -f "$API_SCRIPT"
            echo "Service stopped."
        else
            echo "Service is not running."
            pkill -f "$API_SCRIPT"
        fi
        ;;
    status)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "Service is running (PID: $(cat "$PID_FILE"))."
        else
            echo "Service is stopped."
        fi
        ;;
    restart)
        $0 stop
        sleep 2
        $0 start
        ;;
    logs)
        tail -f "$LOG_FILE"
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart|logs}"
        exit 1
esac
