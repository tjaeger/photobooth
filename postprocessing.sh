#!/bin/bash

# Source the configuration file
source /home/user/photobooth/config.sh

FILENAME=$1 # Map $1 from Argument into $filename variable

# echo "Filename: $FILENAME" # Print Filename (debug purpose)

killall feh # close all 'feh' processes (the running screenshow)

# Display current taken image for x seconds and stop.
feh -F -D 10 --on-last-slide quit $FILENAME

feh --zoom 20 \
    --randomize \
    --slideshow-delay 5 \
    --fullscreen \
    --hide-pointer \
    --quiet \
    --recursive \
    "$TARGET_DIR" &
