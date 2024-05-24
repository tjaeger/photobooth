#!/bin/sh

# Source the configuration file
source /path/to/config.sh

self=`basename $0`

case "$ACTION" in
   init)
echo "$self: INIT"
# exit 1 # non-null exit to make gphoto2 call fail
;;
   start)
echo "$self: START"
;;
   download)
echo "$self: DOWNLOAD to $ARGUMENT"
./postprocessing.sh "$ARGUMENT"
# ./slideshow.sh
;;
   stop)
echo "$self: STOP"
;;
   *)
echo "$self: Unknown action: $ACTION"
;;
esac

exit 0
