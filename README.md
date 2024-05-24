# Photobooth

Photobooth is a simple script collection designed to build a DSLR-based photobooth running on a Raspberry Pi (RPI). This project allows you to set up a fully functional photobooth with your DSLR camera, capturing high-quality images and displaying them directly on the RPI using `feh`.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Introduction

Photobooth is aimed at hobbyists and professionals who want to create a DIY photobooth using their DSLR camera and a Raspberry Pi. The scripts provided in this collection will help you capture, display, and manage photos effortlessly.

## Features

- Capture high-quality photos using a DSLR camera
- Store photos directly on the Raspberry Pi
- Display photos using `feh`
- Easy to set up and configure

## Requirements

To get started with Photobooth, you'll need the following hardware and software:

### Hardware

- Raspberry Pi (any model with USB support)
  Currently working with RPI5
- DSLR Camera with USB connectivity and TETHERED SHOOTING Functionality
- USB Cable to connect the DSLR to the RPI
- HDMI Monitor for the RPI
- Keyboard and mouse for initial setup
- SD card with Raspberry Pi OS installed
- Optional external USB SSD Drive for Image Storage)

- tested Setup
-- NIKON D90
-- RF603II yongnuo (Radio remote control - built into Buzzer)
-- 2x YN560 external Flash

### Software

- Raspberry Pi OS (latest version recommended)
- gPhoto2
- feh (for image display)

## Installation

Follow these steps to install and set up Photobooth on your Raspberry Pi:

1. **Update your Raspberry Pi:**
    ```sh
    sudo apt update && sudo apt upgrade -y
    ```

2. **Install libgphoto2 & gPhoto2 :**

http://www.gphoto.org and download libgphoto2
Get gphoto2 from https://github.com/gphoto/gphoto2

This installs autoconf, needed for compiling later
```sh
  apt install autoconf
  apt install autopoint
```

```sh
    $ cd libgphoto2-2.5.22
    $ autoreconf -is
    $ sudo ./configure
    $ sudo make
    $ sudo make install
```
Example for Build/Install for gphoto2
```sh
autoreconf --install —symlink
  ./configure
  make
  sudo make install
```

3. **Install feh:**
    ```sh
    sudo apt-get --purge remove feh
    sudo apt-get install libcurl4-openssl-dev libx11-dev libxt-dev libimlib2-dev libxinerama-dev libjpeg-progs libpng-dev libexif-dev libexif12
    mkdir Feh_Build
    
    cd Feh_Build
    wget https://feh.finalrewind.org/feh-2.28.1.tar.bz2
    tar jxvf feh-2.28.1.tar.bz2
    cd feh-2.28.1

    make -j4 curl=0 xinerama=0 verscmp=1
    sudo make install
    sudo ldconfig

    feh --version
    ```

4. **Clone the Photobooth repository:**
    ```sh
    git clone git@github.com:tjaeger/photobooth.git
    cd photobooth
    ```

## Usage

To start the Photobooth application, navigate to the project directory and run the main script:

```sh
./photobooth.sh
