#!/bin/bash

# ============================================
# Automated Server Monitoring Script with Slack Alerts
# Author: Shrish Pattewar
# ============================================

# === Configuration ===
LOGFILE="/var/log/server_monitor.log"
THRESHOLD_CPU=80       # CPU usage threshold (%)
THRESHOLD_MEM=80       # Memory usage threshold (%)
THRESHOLD_DISK=80      # Disk usage threshold (%)
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/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"

# === Date and Hostname ===
DATE=$(date "+%Y-%m-%d %H:%M:%S")
HOST=$(hostname)

# === Fetch Metrics ===
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')    # % CPU usage
MEM=$(free | awk '/Mem:/ {printf "%.2f", $3/$2 * 100}')      # % Memory usage
DISK=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//g')      # % Disk usage

# === Log Entry ===
echo "$DATE | Host: $HOST | CPU: ${CPU}% | MEM: ${MEM}% | DISK: ${DISK}%" >> $LOGFILE

# === Slack Alert Function ===
send_alert() {
    local metric=$1
    local value=$2
    local threshold=$3
    local message="ALERT on $HOST - $metric usage is at $value%, exceeded threshold $threshold%."
    curl -X POST -H 'Content-type: application/json' --data "{\"text\": \"$message\"}" $SLACK_WEBHOOK_URL
}

# === Check Thresholds ===
if (( ${CPU%.*} > THRESHOLD_CPU )); then
    send_alert "CPU" "$CPU" "$THRESHOLD_CPU"
fi

if (( ${MEM%.*} > THRESHOLD_MEM )); then
    send_alert "Memory" "$MEM" "$THRESHOLD_MEM"
fi

if (( ${DISK%.*} > THRESHOLD_DISK )); then
    send_alert "Disk" "$DISK" "$THRESHOLD_DISK"
fi

# === Test Slack Alert ===
# Uncomment the line below to test
# curl -X POST -H 'Content-type: application/json' --data '{"text":"Test message from Server Monitoring Script."}' $SLACK_WEBHOOK_URL

