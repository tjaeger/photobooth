#!/bin/bash

# Source the configuration file
source config.sh

# Ensure the target directory exists
mkdir -p "$TARGET_DIR"

# Function to check if the camera is connected
check_camera_connected() {
    if gphoto2 --auto-detect | grep -q 'usb:'; then
        return 0
    else
        return 1
    fi
}

# Function to start gphoto2 with tethered capture
start_gphoto2() {
    # Generate a UUID
    UUID=$(uuid)

    # Get the current date and time in a readable format
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

    # Execute gphoto2 with tethered capture
    gphoto2 --capture-tethered \
        --hook-script=hookscript.sh \
        --filename="$TARGET_DIR/PB_${TIMESTAMP}_${UUID}.%C" \
        --quiet &

    GPHOTO2_PID=$!
}

# Function to stop gphoto2
stop_gphoto2() {
    if [ -n "$GPHTO2_PID" ] && kill -0 $GPHTO2_PID 2>/dev/null; then
        kill $GPHTO2_PID
        wait $GPHTO2_PID
    fi
}

GPHTO2_PID=""

# Main loop to check camera connection and start/stop gphoto2
while true; do
    if check_camera_connected; then
        if [ -z "$GPHTO2_PID" ] || ! kill -0 $GPHTO2_PID 2>/dev/null; then
            echo "Camera connected, starting gphoto2..."
            start_gphoto2
        fi
    else
        if [ -n "$GPHTO2_PID" ] && kill -0 $GPHTO2_PID 2>/dev/null; then
            echo "Camera disconnected, stopping gphoto2..."
            stop_gphoto2
            GPHTO2_PID=""
        fi
    fi
    sleep 5
done
