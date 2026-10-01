#!/bin/bash

LOGFILE="/home/prokdevops/devops-lab/logs/health-check.log"

STATUS="OK"

exec >> "$LOGFILE"

echo "===================="
echo "Server health check started - $(date)"
echo "===================="

echo "Hostname:"
hostname

echo "Disk usage:"
df -h /

DISK_USAGE=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')

if [ "$DISK_USAGE" -ge 80 ]; then
    echo "Disk status: WARNING ($DISK_USAGE%)"
    STATUS="WARNING"
else
    echo "Disk status: OK ($DISK_USAGE%)"
fi



echo "Memory usage:"
free -h

MEMORY_USAGE=$(free | awk '/^Mem:/ {printf "%.0f", ($3/$2)*100}')

if [ "$MEMORY_USAGE" -ge 80 ]; then
    echo "Memory status: WARNING ($MEMORY_USAGE%)"
    STATUS="WARNING"
else
    echo "Memory status: OK ($MEMORY_USAGE%)"
fi

echo "Overall status: $STATUS"

echo "========================"
echo "Health check completed"
echo "========================"

if [ "$STATUS" = "OK" ]; then
    exit 0
else
    exit 1
fi
