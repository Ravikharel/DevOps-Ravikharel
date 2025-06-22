#!/bin/bash

SERVICE_LIST="services.txt"
LOGFILE="logs/monitor.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

mkdir -p logs

echo "[$DATE] Checking services..." >> "$LOGFILE"

while IFS= read -r service
do
    if systemctl is-active --quiet "$service"; then
        echo "✅ $service is running." | tee -a "$LOGFILE"
    else
        echo "❌ $service is not running. Restarting..." | tee -a "$LOGFILE"
        systemctl start "$service"
        if [ $? -eq 0 ]; then
            echo "🔁 $service restarted successfully." | tee -a "$LOGFILE"
        else
            echo "🚨 Failed to restart $service!" | tee -a "$LOGFILE"
        fi
    fi
done < "$SERVICE_LIST"

echo "" >> "$LOGFILE"
