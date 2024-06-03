#!/bin/bash

# Source the configuration file
source ./config.sh

filename="$TARGET_DIR/PB_%H%M%S$uuid.%C"

# Ensure the target directory exists
mkdir -p "$TARGET_DIR"

# Get the current date and time in a readable format
TIMESTAMP=$(date +"%Y%m%d_%H%M%S%3N")

# Execute gphoto2 with tethered capture
gphoto2 --capture-tethered \
    --hook-script=hookscript.sh \
    --filename="$TARGET_DIR/PB_${TIMESTAMP}.%C" \
    --quiet

# Check if gphoto2 command was successful
if [ $? -eq 0 ]; then
    echo "Photo captured and saved successfully."
else
    echo "Failed to capture photo." >&2
    exit 1
fi
