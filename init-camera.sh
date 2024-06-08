#!/bin/bash

# This script allows to set values to the Camera before tethered-shooting.
# In typical Photobooth setups, the settings in the Camera are manual. This script will avoid accidential changing of Manual Values,
# in particular Aperture/Speed. Of course other values (eg ISO) can be set too.

# Define the configuration names and values
# This is for a NIKON D90. Other Cameras might have different names.
# 'gphoto2 --list-config' will tell the Variables/names of your attached Camera


SHUTTER_SPEED="shutterspeed"
APERTURE="f-number"
SHUTTER_SPEED_VALUE="1/125"
APERTURE_VALUE="7"

# The Aperture Value (F-number) is x+1. So a '7' is an Aperture 8 in the camera.

# Set the shutter speed
gphoto2 --set-config $SHUTTER_SPEED=$SHUTTER_SPEED_VALUE

# Set the aperture
gphoto2 --set-config $APERTURE=$APERTURE_VALUE
