#!/bin/bash

# Source the configuration file
source config.sh

killall feh # close all 'feh' processes (the running screenshow)

# Display a static Image (eg quick Instructions) and show 'ready for action'.
# That process is being killed when postprocessing.sh gets called

feh --zoom 80 \
    --fullscreen \
    --hide-pointer \
    --quiet \
    "info_DE.JPG" &
