#!/bin/bash

LOG_DIR="logs"
LOGFILE="$LOG_DIR/health.log"
HTML_FILE="dashboard.html"
INTERVAL=5  # update every 5 seconds

mkdir -p "$LOG_DIR"

while true; do
    # Gather data
    DATE=$(date)
    UPTIME=$(uptime -p)
    LOAD=$(uptime | awk -F'load average: ' '{print $2}')
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')  # Idle value is $8
    MEM=$(free -m | awk '/Mem:/ {printf("%.2f", $3/$2 * 100)}')
    DISK=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

    # Logging (optional)
    echo "$DATE | CPU: ${CPU}% | MEM: ${MEM}% | DISK: ${DISK}% | LOAD: $LOAD" >> "$LOGFILE"

    # Create HTML dashboard
    cat <<EOF > $HTML_FILE
<html>
<head>
    <title>Server Health Dashboard</title>
    <meta http-equiv="refresh" content="$INTERVAL">
    <style>
        body { font-family: Arial; padding: 20px; background: #f9f9f9; }
        h1 { color: #333; }
        table { border-collapse: collapse; width: 60%; }
        td, th { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #eee; }
    </style>
</head>
<body>
    <h1>🩺 Server Health Dashboard</h1>
    <p><strong>Last Updated:</strong> $DATE</p>
    <table>
        <tr><th>Metric</th><th>Value</th></tr>
        <tr><td>Uptime</td><td>$UPTIME</td></tr>
        <tr><td>CPU Usage</td><td>$CPU %</td></tr>
        <tr><td>Memory Usage</td><td>$MEM %</td></tr>
        <tr><td>Disk Usage (/)</td><td>$DISK %</td></tr>
        <tr><td>Load Average</td><td>$LOAD</td></tr>
    </table>
</body>
</html>
EOF

    echo "[$DATE] Dashboard updated..."
    sleep $INTERVAL
done

