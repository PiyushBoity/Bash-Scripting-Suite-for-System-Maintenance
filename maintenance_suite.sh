#!/bin/bash
# Combines system update/cleanup and log monitoring with menu
# Adds error handling, timestamps, and enhanced logging
# -------------------------------
# Functions
# -------------------------------

system_update_cleanup() {
    LOGFILE="./system_update_cleanup_log_$(date +%Y%m%d_%H%M%S).txt"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - Starting system update and cleanup..." | tee -a "$LOGFILE"

    if sudo apt update -y >> "$LOGFILE" 2>&1; then
        echo "$(date) - Package list updated successfully." >> "$LOGFILE"
    else
        echo "$(date) - ERROR: Failed to update package list." >> "$LOGFILE"
    fi

    if sudo apt upgrade -y >> "$LOGFILE" 2>&1; then
        echo "$(date) - Packages upgraded successfully." >> "$LOGFILE"
    else
        echo "$(date) - ERROR: Failed to upgrade packages." >> "$LOGFILE"
    fi

    if sudo apt autoremove -y >> "$LOGFILE" 2>&1; then
        echo "$(date) - Unnecessary packages removed successfully." >> "$LOGFILE"
    else
        echo "$(date) - ERROR: Failed to remove unnecessary packages." >> "$LOGFILE"
    fi

    if sudo apt autoclean -y >> "$LOGFILE" 2>&1; then
        echo "$(date) - Package cache cleaned successfully." >> "$LOGFILE"
    else
        echo "$(date) - ERROR: Failed to clean package cache." >> "$LOGFILE"
    fi

    echo "$(date) - System update and cleanup finished!" | tee -a "$LOGFILE"
    echo "Log saved at $LOGFILE"
}

log_monitor() {
    LOG_FILE="/var/log/syslog"
    ALERT_LOG="./log_alerts_$(date +%Y%m%d_%H%M%S).txt"
    KEYWORDS=("error" "fail" "denied" "critical")
    INTERVAL=10

    # Check if log file exists
    if [ ! -f "$LOG_FILE" ]; then
        echo "$(date) - ERROR: Log file $LOG_FILE does not exist." | tee -a "$ALERT_LOG"
        return 1
    fi

    # Start monitoring silently
    echo "$(date) - Starting continuous log monitoring on $LOG_FILE" >> "$ALERT_LOG"
    LAST_LINE=0
    while true; do
        TOTAL_LINES=$(wc -l < "$LOG_FILE")
        if [ "$TOTAL_LINES" -gt "$LAST_LINE" ]; then
            NEW_LINES=$(tail -n $((TOTAL_LINES - LAST_LINE)) "$LOG_FILE")
            for keyword in "${KEYWORDS[@]}"; do
                MATCHES=$(echo "$NEW_LINES" | grep -i "$keyword")
                if [ ! -z "$MATCHES" ]; then
                    echo "$(date) - ALERT: Found '$keyword' entries:" >> "$ALERT_LOG"
                    echo "$MATCHES" >> "$ALERT_LOG"
                fi
            done
            LAST_LINE=$TOTAL_LINES
        fi
        sleep $INTERVAL
    done
}

# -------------------------------
# Main menu
# -------------------------------
LOG_MONITOR_PID=0

while true; do
    echo "=============================="
    echo "  System Maintenance Suite"
    echo "=============================="
    echo "1. System Update & Cleanup"
    echo "2. Start Log Monitoring (Background)"
    echo "3. Stop Log Monitoring"
    echo "4. Exit"
    echo "=============================="
    read -p "Enter your choice [1-4]: " choice

    case $choice in
        1) system_update_cleanup ;;
        2)
            if [ $LOG_MONITOR_PID -eq 0 ]; then
                log_monitor > /dev/null 2>&1 &
                LOG_MONITOR_PID=$!
                echo "$(date) - Log monitoring started in background (PID: $LOG_MONITOR_PID). Alerts saved in alert log."
            else
                echo "Log monitoring is already running (PID: $LOG_MONITOR_PID)."
            fi
            ;;
        3)
            if [ $LOG_MONITOR_PID -ne 0 ]; then
                if kill $LOG_MONITOR_PID 2>/dev/null; then
                    echo "$(date) - Log monitoring stopped."
                    LOG_MONITOR_PID=0
                else
                    echo "$(date) - ERROR: Failed to stop log monitoring (PID: $LOG_MONITOR_PID)."
                fi
            else
                echo "No background log monitoring process found."
            fi
            ;;
        4)
            if [ $LOG_MONITOR_PID -ne 0 ]; then
                kill $LOG_MONITOR_PID 2>/dev/null
            fi
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice! Please select 1-4."
            ;;
    esac
done

