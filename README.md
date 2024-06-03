# Photobooth

Photobooth is a simple script collection designed to build a DSLR-based photobooth running on a Raspberry Pi (RPI), capturing high-quality images and displaying them directly on the RPI using `feh`.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Requirements](#requirements)
  - [Hardware & Software](#hardware)
- [Software Setup](#software-setup)
  - [Install 'libgphoto2' & 'gphoto2'](#2-install-libgphoto2-and-gphoto2)
  - [Install 'feh'](#3-install-feh-image-viewer)
  - [Install 'photobooth scripts'](#4-install-the-photobooth-scripts)
  - [Install 'imagemagick'](#5-install-imagemagick-for-image-manipulationhandling)
  - [Post-Install cleanup](#6-post-installation-cleanup)
- [Options](#options)
  - [Backup - add external Drive](#backup---add-external-usb-drive)
  - [Backup - setup automatic backup](#backup---automatic-backup-of-images)
- [Run the Photobooth](#run-the-photobooth)
  - [RUN - init and Preflight check](#init-and-pre-flight-check)
  - [RUN - Photobooth](#run-the-software)
  - [Files/Scripts and their role](#scripts---and-what-they-do)

## Introduction
Photobooth is aimed at hobbyists who want to create a DIY photobooth using their DSLR camera and a Raspberry Pi. The scripts provided in this collection will help you capture, display, and manage photos effortlessly.

## Features
- Capture high-quality photos using a DSLR camera in 'tethered mode'
  - All Camera/Flash stuff is managed by 'Camera gear'. 
  - Camera trigger is a Radio remote Buzzer - no fiddling with buttons on a screen
- Store photos directly on the Raspberry Pi and optional attached storage (eg USB Disc)
- Display photos using `feh`
- Easy to set up and configure. All based around scripts


# Requirements
To get started with Photobooth, you'll need the following hardware and Software

## Hardware
- Raspberry Pi (any model with USB support - i am using RPI5/8G/64G SDcard)
- DSLR Camera with USB connectivity and TETHERED SHOOTING Functionality
- USB Cable to connect the DSLR to the RPI
- HDMI Monitor for the RPI, or DSI Display (i use a 7" original RPI Display)
- Keyboard and mouse for initial setup
- Optional external USB SSD Drive for Image Storage

- Tested Setup
  - NIKON D90, D7000
  - RF603II yongnuo (Radio remote control - built into Buzzer)
  - 2x YN560 external Flash

Optional HW: External LED, Button for headless RPI management.

## Software
I am using the latest RPI-OS 64bit

```sh
$ lsb_release -a
[...]
Description:	Debian GNU/Linux 12 (bookworm)
Release:	12

$ uname -a
Linux photobooth 6.6.31-v8-16k+ #1766 SMP PREEMPT Fri May 24 12:15:34 BST 2024 aarch64 GNU/Linux
```

# Software Setup

## 1. **Update your Raspberry Pi:**
```sh
sudo apt update && sudo apt upgrade -y
```

## 2. **Install libgphoto2 and gphoto2**
The 'photobooth' directory will be installed in the users home directory. In this case the user is named 'user'.
```home/user/photobooth```



### Install Dependencies
This installs autoconf and other tools/libraries, needed for compiling later
```sh
sudo apt install autoconf
sudo apt install autopoint
sudo apt install libtool
sudo apt install libpopt-dev
```
### Install libgphoto2
https://github.com/gphoto/libgphoto2/releases

```sh
cd ~/
git clone https://github.com/gphoto/libgphoto2.git
cd libgphoto2
autoreconf --install --symlink
./configure
make
sudo make install
```

### Install gphoto2
https://github.com/gphoto/gphoto2/releases

```sh
cd ~/
git clone https://github.com/gphoto/gphoto2.git
cd gphoto2
autoreconf --install --symlink
./configure
make
sudo make install
```


```sh
sudo apt autoremove
sudo reboot
```

```sh
gphoto2 -v
```

## 3. **Install FEH Image viewer**
```sh
sudo apt --purge remove feh
sudo apt install -y libcurl4-openssl-dev libx11-dev libxt-dev libimlib2-dev libxinerama-dev libjpeg-progs libpng-dev libexif-dev libexif12

cd ~/
git clone https://github.com/derf/feh.git
cd feh

make -j4 curl=0 xinerama=0 verscmp=1
sudo make install
sudo ldconfig

feh --version
```
## 4. Install the PHOTOBOOTH scripts
This assumes the user is called 'user' (in case it's 'pi' or others please adjust paths)

```sh
cd ~/
git clone git@github.com:tjaeger/photobooth.git
mkdir photobooth/pictures
cd photobooth

```
use https://github.com/tjaeger/photobooth.git if you havent setup git using sshkey

## 5. **Install ImageMagick for Image Manipulation/handling**
(Once optional, it's mandatory now as its needed for Image Transformation/Handling/Manipulation - eg for creating Thumbnails)

Get the Source
```sh
cd ~/
git clone https://github.com/ImageMagick/ImageMagick.git
cd ImageMagick
git tag --sort=-v:refname ## Lets find the latest TAG - 7.1.1-33 in our case - INFORMATIVE step
git describe --tags ## Lets see whats the current tag we checked out - INFORMATIVE step
````

```sh
cd ~/ImageMagick
./configure
make
sudo make install
sudo ldconfig /usr/local/lib
````

Check if it got installed ```magick -version```


# Troubleshooting

## gvfs blocking access to Camera

```sh
*** Error ***
An error occurred in the io-library ('Could not claim the USB device'): Could not claim interface 0 (Device or resource busy). Make sure no other program (gvfs-gphoto2-volume-monitor) or kernel module (such as sdc2xx, stv680, spca50x) is using the device and you have read/write access to the device.
*** Error (-53: 'Could not claim the USB device') ***
```


https://www.reddit.com/r/linuxquestions/comments/gfi31i/can_gvfs_be_disabled_and_removed/

```sh
systemctl --user stop gvfs* # stop all services with gvfs
sudo kill $(ps -A | grep gvfs | awk '{print $1}') # to be sure GVFS is not running
sudo chmod 0000 /usr/lib/systemd/user/gvfs* # this prevent GVFS from starting
```

```sudo reboot``` and try again

## 6. **Post-Installation CLEANUP**
Once all the above packages are compiled and installed successfully, the Build Directorties can be deleted.

```sh
cd ~/
sudo rm -r libgphoto2
sudo rm -r gphoto2
sudo rm -r feh
sudo rm -r ImageMagick
```

# Options

## **BACKUP - Add external USB Drive**
**This assumes you have an attached USB(SSD) Drive attached and formatted EXT4 !!**

```sh
sudo ls -l /dev/disk/by-uuid/
```
RESULT - keep the UUID of /sda1

```sh
$ lrwxrwxrwx 1 root root 10 Jun  1 17:43 9dac7f3d-c7c2-4706-b43f-b3ecded1a3b3 -> ../../sda1
```

Create a Mount point (a directory which will be your USB/SSD Drive)
```sh
mkdir ~/ssdusb
```

We want this to mounted each start automatically. Open /etc/fstab:

```sh
sudo nano /etc/fstab
UUID=<replace-with-your-uuid> /home/user/ssdusb ext4 defaults 0 0

$ sudo reboot
```

UUID=
Replace <replace-with-your-uuid> with your UUID from ```sudo ls -l /dev/disk/by-uuid/``` before.
Replace uid= and gid= with your system user. Its 'user' in our case. Could be 'pi' or anything else as well.
```/home/user/ssdusb``` also may be different, depending on your choice.

So in my case the line looks like:
```UUID=9dac7f3d-c7c2-4706-b43f-b3ecded1a3b3 /home/user/ssdusb ext4 defaults 0 0```

Check if the USB SSD is mounted correctly
```sh
sudo mount
```
or check the mount point - ```/home/user/ssdusb```


## **BACKUP - Automatic Backup of Images**
In this setup the RPI runs off a SDCARD. To prevent loss in case of SDCARD Damage there is a helper script to create a local Backup to an external Drive - a USB-SSD Drive in my case.
The script is called ```backup_images.sh``` and is triggered by CRON.

In this case CRON calls the script every 5 Minutes, checks for Delta, and copies the new Images
Use crontab to edit the CRONJOB File and add the below line ```*/5 * * * * /home/user/photobooth/backup_images.sh```

```sh
crontab -e
*/5 * * * * /home/user/photobooth/backup_images.sh
```
Note: On each script execution logfile.log is being created/extended with the
START/END datetime and the Files being copied.

### Check 
You can ```tail -f logfile.log``` to see whether CRON calls the script.


## EXTERNAL Status LEDs and PWR-Down button
I am using an external Button so safely shutdown RPI.
Also using external LED for both 
1. RPI Power-on (ON when RPI is on)
2. MMC Activity (flickers ON when there is MMC activit)

Modify your config.txt to set this up, adding the below lines.

```/boot/firmware/config.txt```

```sh
# PWR and ACT LED + Shutdown button
enable_uart=1
dtoverlay=gpio-shutdown,gpio_pin=3,active_low=1,debounce=2000

# Enables a permanent ext PWR-LED
dtparam=pwr_led_gpio=17
# dtparam=pwr_led_gpio=17, pwr_led_trigger=heartbeat

# Enables ACT-LED. Normally OFF when not active.
dtparam=act_led_gpio=27,act_led_trigger=mmc0,act_led_activelow=off
```
## **RUN THE PHOTOBOOTH**

### Init and Pre-flight check
Run the ```preflight-check.sh``` script from within ./photobooth directory.
It will do some sanity checks like verify if various Paths exist. It also offers to create the 'pictures' directory if not existing.  
**You only really need this after a fresh install.**

```sh
~/photobooth $ 
.
├── backup_images.sh
├── config.sh
├── hookscript.sh
├── init-camera.sh
├── logfile.log
├── photobooth.sh
├── postprocessing.sh
├── preflight-check.sh
├── README.md
└── showinfo.sh
├── pictures
│   ├── 
```

### Run the Software
on the RPI itself start
```sh
cd ~/
./photobooth.sh
```
If you run this from a remote console (eg SSH):
```sh
cd ~/
DISPLAY=:0 ./photobooth.sh &
```
### Scripts - and what they do


`config.sh`  
Contains some central variables, used across scripts. 

`photobooth.sh`  
The Main Script. Basically calls gphoto2 in tethered-shooting mode.

`hookscript.sh`  
Is called by gphoto2 (which is called by photobooth.sh).
Init, Download and Post-Action can be defined which can call more action (scripts)
Mainly using  (download) section - which calls `postprocessing.sh` which than:

`postprocessing.sh`  
Displays an Image (name passed as Argument by gphoto2/hookscript) temporary.
This could call another script that randomly displays a Slideshow of taken Images.

`backup_images.sh`  
**Optional:** Run by CRON and crating regular backup of Images.
It must contain absolut paths (i am using relative path/variables whenever possible) as its called by CRON which doesnt assume to run from /photobooth

`preflight-check.sh`  
**Optional:** to use after fresh install. It performs some sanity checks and creates needed Directories on request.

`init-camera.sh`  
**Optional:** to set parameters in the Camera (eg Aperture/Speed). This could be called manually or from within hookscript.sh in the (init) or (start) section.

`showinfo.sh`  
**Optional:** Displays a static Image (eg 'look into camera and press buzzer'). This could be called from within `hookscript.sh' in the (init) section
