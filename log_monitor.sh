#!/bin/bash
# Adds error handling, timestamps, and enhanced logging

# -------------------------------
# Configuration
# -------------------------------
LOG_FILE="/var/log/syslog"  # Log file to monitor
ALERT_LOG="./log_alerts_$(date +%Y%m%d_%H%M%S).txt"
KEYWORDS=("error" "fail" "denied" "critical")
INTERVAL=10  # Check every 10 seconds

# -------------------------------
# Functions
# -------------------------------
print_msg() {
    echo -e "\e[1;32m$1\e[0m"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$ALERT_LOG"
}

print_alert() {
    echo -e "\e[1;31mALERT: $1\e[0m"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - ALERT: $1" >> "$ALERT_LOG"
}

print_error() {
    echo -e "\e[1;31mERROR: $1\e[0m"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - ERROR: $1" >> "$ALERT_LOG"
}

# -------------------------------
# Check if log file exists
# -------------------------------
if [ ! -f "$LOG_FILE" ]; then
    print_error "Log file $LOG_FILE does not exist. Exiting."
    exit 1
fi

print_msg "Starting continuous log monitoring on $LOG_FILE..."
echo "Log monitoring started at $(date)" >> "$ALERT_LOG"

# -------------------------------
# Monitor logs continuously
# -------------------------------
LAST_LINE=0

while true; do
    TOTAL_LINES=$(wc -l < "$LOG_FILE")

    if [ "$TOTAL_LINES" -gt "$LAST_LINE" ]; then
        NEW_LINES=$(tail -n $((TOTAL_LINES - LAST_LINE)) "$LOG_FILE")
        for keyword in "${KEYWORDS[@]}"; do
            MATCHES=$(echo "$NEW_LINES" | grep -i "$keyword")
            if [ ! -z "$MATCHES" ]; then
                print_alert "Found '$keyword' entries:"
                echo "$MATCHES" >> "$ALERT_LOG"
            fi
        done
        LAST_LINE=$TOTAL_LINES
    fi

    sleep $INTERVAL
done

