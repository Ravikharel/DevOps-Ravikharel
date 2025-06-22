#!/bin/bash

THRESHOLD=80

echo "Checking disk usage at: $(date)"
echo "------------------------------"

# Use df to get disk usage info, skipping headers and loop devices
df -H | grep '^/dev/' | while read line; do
    usage=$(echo $line | awk '{print $5}' | sed 's/%//')
    partition=$(echo $line | awk '{print $1}')
    mount_point=$(echo $line | awk '{print $6}')

    if [ "$usage" -ge "$THRESHOLD" ]; then
        echo "⚠️  ALERT: $partition mounted on $mount_point is at ${usage}% usage"
    else
        echo "✅ OK: $partition on $mount_point is at ${usage}% usage"
    fi
done

