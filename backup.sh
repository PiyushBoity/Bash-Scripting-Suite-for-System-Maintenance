#!/bin/bash
SOURCE="/mnt/c/users/piyus/Documents"
DEST="/mnt/c/users/piyus/OneDrive/Documents/Desktop/backup_folder/backup_$(date +%Y%m%d_%H%M%S)"
LOGFILE="./backup_log_$(date +%Y%m%d_%H%M%S).txt"

print_msg() { echo -e "\e[1;32m$1\e[0m"; echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"; }
print_error() { echo -e "\e[1;31m$1\e[0m"; echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"; }

print_msg "Starting system backup..."
mkdir -p "$DEST"

if cp -r "$SOURCE"/* "$DEST" 2>/dev/null; then
    print_msg "Backup completed successfully!"
    print_msg "Backup stored at: $DEST"
else
    print_error "Backup failed. Please check directory permissions."
fi

