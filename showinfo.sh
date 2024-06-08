#!/bin/bash

# Source the configuration file
source /home/user/photobooth/config.sh

killall feh # close all 'feh' processes (the running screenshow)

# Display a static Image (eg quick Instructions) and show 'ready for action'.
# That process is being killed when postprocessing.sh gets called

feh --zoom 80 \
    --hide-pointer \
    --quiet \
    --geometry 800x480+0+0 \
    "./photobooth_assets/info_DE.JPG"

