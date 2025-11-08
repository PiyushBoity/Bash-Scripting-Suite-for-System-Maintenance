# Bash-Scripting-Suite-for-System-Maintenance

## Overview
This project is all about making routine Linux system maintenance easier and more efficient using Bash scripts. It includes tools to:

- **Update and clean your system**
- **Monitor system logs for important events**
- **Back up important files**
- **Run all these tasks from a single, easy-to-use menu**

Every script comes with **error handling**, **timestamped logging**, and is designed to be **reliable and user-friendly**.

---

## Features

### 1. System Update & Cleanup (`system_update.sh`)
- Automatically updates package lists and upgrades installed packages
- Removes unnecessary packages and cleans cache
- Logs every action with timestamps and error messages if something goes wrong

### 2. Log Monitoring (`log_monitor.sh`)
- Continuously watches `/var/log/syslog` for important keywords: `error`, `fail`, `denied`, `critical`
- Saves alerts with timestamps
- Handles missing log files gracefully, so it won’t crash

### 3. Backup (`backup.sh`)
- Creates a timestamped backup of your specified folders
- Logs all backup actions
- Shows clear success or error messages
- Easy to customize source and destination paths

### 4. Maintenance Suite (`maintenance_suite.sh`)
- Combines system update, log monitoring, and backup into a simple menu
- Log monitoring can run in the background safely
- Start/stop monitoring without errors
- Keeps logs of all actions for easy tracking

---

## Requirements
- Linux OS
- Bash shell
- sudo privileges for system update/cleanup
- Write permissions for backup directories

---

## How to Use

### 1. Backup
```bash
chmod +x backup.sh
./backup.sh
```
- Your files will be backed up to a timestamped folder.
- A log of the backup will also be created.
### 2. System Update & Cleanup
```bash
chmod +x system_update.sh
./system_update.sh
```
- The script will create a log file showing everything that happened.
### 3. Log Monitoring
```bash
chmod +x log_monitor.sh
./log_monitor.sh
```
- Any alerts will be saved in a timestamped log file.
### 4. Maintenance Suite
```bash
chmod +x maintenance_suite.sh
./maintenance_suite.sh
```
Follow the menu to choose tasks:
```bash
==============================
  System Maintenance Suite
==============================
1. System Update & Cleanup
2. Start Log Monitoring (Background)
3. Stop Log Monitoring
4. Backup
5. Exit
==============================
Enter your choice [1-5]:
```

## Project Summary

This Capstone project demonstrates how Linux system maintenance can be automated using Bash scripts. It includes **backup, system update & cleanup, log monitoring**, and a **menu-driven maintenance suite**. All scripts are designed to be **robust, user-friendly, and safe**, with **error handling and timestamped logging**.  

By automating these tasks, the project reduces manual effort, minimizes errors, and provides an efficient way to maintain Linux systems. Overall, it showcases practical skills in **automation, monitoring, and system administration**.
