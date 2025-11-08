#!/bin/bash
# Adds error handling, timestamps, and improved logging

# -------------------------------
# Setup log file
# -------------------------------
LOGFILE="./system_update_cleanup_log_$(date +%Y%m%d_%H%M%S).txt"

# Function to print colored messages
print_msg() {
    echo -e "\e[1;32m$1\e[0m"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}

# Function to print error messages
print_error() {
    echo -e "\e[1;31m$1\e[0m"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - ERROR: $1" >> "$LOGFILE"
}

print_msg "Starting system update and cleanup..."
echo "----------------------------------------" >> "$LOGFILE"
echo "System Update and Cleanup Log - $(date)" >> "$LOGFILE"
echo "----------------------------------------" >> "$LOGFILE"

# -------------------------------
# Step 1: Update package list
# -------------------------------
print_msg "Updating package list..."
if sudo apt update -y >> "$LOGFILE" 2>&1; then
    print_msg "Package list updated successfully."
else
    print_error "Failed to update package list."
fi

# -------------------------------
# Step 2: Upgrade installed packages
# -------------------------------
print_msg "Upgrading installed packages..."
if sudo apt upgrade -y >> "$LOGFILE" 2>&1; then
    print_msg "Packages upgraded successfully."
else
    print_error "Failed to upgrade packages."
fi

# -------------------------------
# Step 3: Remove unnecessary packages
# -------------------------------
print_msg "Removing unnecessary packages..."
if sudo apt autoremove -y >> "$LOGFILE" 2>&1; then
    print_msg "Unnecessary packages removed successfully."
else
    print_error "Failed to remove unnecessary packages."
fi

# -------------------------------
# Step 4: Clean package cache
# -------------------------------
print_msg "Cleaning package cache..."
if sudo apt autoclean -y >> "$LOGFILE" 2>&1; then
    print_msg "Package cache cleaned successfully."
else
    print_error "Failed to clean package cache."
fi

# -------------------------------
# Completion message
# -------------------------------
print_msg "System update and cleanup finished successfully!"
print_msg "Log file saved at: $LOGFILE"

