#!/bin/sh

# Source the configuration file
source /home/user/photobooth/config.sh

self=`basename $0`

case "$ACTION" in
   init)
echo "$self: INIT"
# exit 1 # non-null exit to make gphoto2 call fail
;;
   start)
echo "$self: START"
# When the script and calls gphoto, a static image is shown (quick info, 'look into camera')
./showinfo.sh
;;
   download)
echo "$self: DOWNLOAD to $ARGUMENT"
# After Photo is taken and downloaded to RPI, the script will display the shot Photo
./postprocessing.sh "$ARGUMENT"
;;
   stop)
echo "$self: STOP"
;;
   *)
echo "$self: Unknown action: $ACTION"
;;
esac

exit 0
