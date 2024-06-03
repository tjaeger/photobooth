#!/bin/bash

# Define the configuration names and values
SHUTTER_SPEED="shutterspeed"
APERTURE="f-number"
SHUTTER_SPEED_VALUE="1/125"
APERTURE_VALUE="7"

# The Aperture Value (F-number) is x+1. So a '7' is an Aperture 8 in the camera.

# Set the shutter speed
gphoto2 --set-config $SHUTTER_SPEED=$SHUTTER_SPEED_VALUE

# Set the aperture
gphoto2 --set-config $APERTURE=$APERTURE_VALUE
