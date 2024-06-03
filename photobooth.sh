#!/bin/bash

# Source the configuration file
source ./config.sh

# Function to check if the script is run from the BASE_DIR directory(->config.sh)
check_base_dir() {
    local current_dir=$(pwd)
    if [[ "$current_dir" != "$BASE_DIR" ]]; then
        echo "Error: Please run the script from the $BASE_DIR directory as defined in config.sh."
        exit 1
    fi
}

# Call the function to check the base directory
check_base_dir

# filename="$TARGET_DIR/PB_%H%M%S$uuid.%C"

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

