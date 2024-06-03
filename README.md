
# Photobooth

Photobooth is a simple script collection designed to build a DSLR-based photobooth running on a Raspberry Pi (RPI). This project allows you to set up a fully functional photobooth with your DSLR camera, capturing high-quality images and displaying them directly on the RPI using `feh`.

## Introduction

Photobooth is aimed at hobbyists and professionals who want to create a DIY photobooth using their DSLR camera and a Raspberry Pi. The scripts provided in this collection will help you capture, display, and manage photos effortlessly.

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
-- NIKON D90, D7000
-- RF603II yongnuo (Radio remote control - built into Buzzer)
-- 2x YN560 external Flash


## Software Setup

1. **Update your Raspberry Pi:**
    ```sh
    sudo apt update && sudo apt upgrade -y
    ```

# 2. **Install libgphoto2 and gphoto2**

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
wget https://github.com/gphoto/libgphoto2/releases/download/v2.5.31/libgphoto2-2.5.31.tar.bz2
tar jxvf libgphoto2-2.5.31.tar.bz2
```
This probably also can be 'git clone' downloaded. Maybe someone can verify.


```sh
cd libgphoto2-2.5.31
autoreconf -is
sudo ./configure
sudo make
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


```sh
```

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


# Options

## Add another USB Drive and create a mount point

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


# MISC

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