#!/bin/bash

# This script will be called by CRON

# Source the configuration file
source /home/user/photobooth/config.sh

# Log the start time
echo "backup START $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"

# Use rsync to copy new files from the source directory to the backup directory
# TARGET_DIR is the specified Path where Images are saved to by gphoto2 (specified in config.sh)
/usr/bin/rsync -av --ignore-existing "$TARGET_DIR/" "$BACKUP_DIR/" >> "$LOG_FILE" 2>&1

# Log the end time
echo "backup END $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"