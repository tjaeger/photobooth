#!/bin/bash

# Source the configuration file
source config.sh

# Use rsync to copy new files from the source directory to the backup directory
# TARGET_DIR is the specified Path where Images are saved to by gphoto2 (specified in config.sh)
rsync -av --ignore-existing "$TARGET_DIR/" "$BACKUP_DIR/" >> "$LOG_FILE" 2>&1
