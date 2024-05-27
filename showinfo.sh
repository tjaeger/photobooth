#!/bin/bash

# Source the configuration file
source config.sh

killall feh # close all 'feh' processes (the running screenshow)

# Display current taken image for x seconds and stop.

feh --zoom 20 \
    --fullscreen \
    --hide-pointer \
    --quiet \
    "info_DE.JPG" &
