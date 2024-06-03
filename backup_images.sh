#!/bin/bash

# This script will be called by CRON and must have absolute path references 

# Source the configuration file
# The Path and Filename of the Image and Backup Directory and Logfile Filename
# is stored in the config.sh file
source /home/user/photobooth/config.sh

# Log the start time
echo "----backup START $(date '+%Y-%m-%d %H:%M:%S')----" >> "$LOG_FILE"

# Check if the backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Backup directory $BACKUP_DIR does not exist." >> "$LOG_FILE"
    echo "----backup FAILED $(date '+%Y-%m-%d %H:%M:%S')----"$'\n' >> "$LOG_FILE"
    exit 1
fi

# Use rsync to copy new files from the source directory to the backup directory
# TARGET_DIR is the specified Path where Images are saved to by gphoto2 (specified in config.sh)
/usr/bin/rsync -av --ignore-existing "$TARGET_DIR/" "$BACKUP_DIR/" >> "$LOG_FILE" 2>&1

# Log the end time
echo "----backup END $(date '+%Y-%m-%d %H:%M:%S')----"$'\n' >> "$LOG_FILE"
