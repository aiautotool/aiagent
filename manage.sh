#!/bin/bash

# Management script for AI Agent API
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
API_SCRIPT="ai_api.py"
LOG_FILE="ai_api.log"
PID_FILE="ai_api.pid"

# Detection of Python (use venv if exists)
if [ -f "$APP_DIR/venv/bin/python3" ]; then
    PYTHON_EXEC="$APP_DIR/venv/bin/python3"
else
    PYTHON_EXEC="python3"
fi

case "$1" in
    start)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "Service is already running (PID: $(cat "$PID_FILE"))."
        else
            echo "Starting AI Agent API using $PYTHON_EXEC..."
            nohup "$PYTHON_EXEC" "$APP_DIR/$API_SCRIPT" > "$APP_DIR/$LOG_FILE" 2>&1 &
            echo $! > "$PID_FILE"
            echo "Service started (PID: $(cat "$PID_FILE"))."
        fi
        ;;
    stop)
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            echo "Stopping AI Agent API (PID: $PID)..."
            kill $PID 2>/dev/null && rm "$PID_FILE"
            # Also pkill just to be sure
            pkill -f "$API_SCRIPT" 2>/dev/null || true
            echo "Service stopped."
        else
            echo "Service is not running."
            pkill -f "$API_SCRIPT" 2>/dev/null || true
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
