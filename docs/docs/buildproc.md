# Build Process

The notes below describe the general build process for creating the
microSD card image.
Some of this now references commands implemented via the `build.sh`
script and its children in the `scripts` directory.


## Preliminaries

The Raspberry Pi kernel source code is kept at
[https://github.com/raspberrypi/linux](https://github.com/raspberrypi/linux).
This code is periodically synchronized with the principal
Linux kernel repository at
[https://www.kernel.org](https://www.kernel.org).
In general, the Raspberry Pi kernel is tracking the 
latest Linux “longterm” family.
This is currently version 4.9.x.
Within the Raspberry Pi Git repository, the branch used is `rpi-4.9.y`.

The build scripts create a compressed binary image
which contains two partitions of a 4 GB microSD card.
The image can be copied to a larger microSD card,
the root filesystem will need to be manually enlarged.

In some cases, a swap partition is desirable.
Such a system was successfully prototyped, but the build scripts here
do not provide one.

Likewise, sometimes primary and secondary root filesystems are desirable.
But these are not provide here.

## The build.sh Script

At this writing, running the script with no arguments
provides the following response:
```text
$ ./build.sh
syntax: build.sh [mkdirs|tools|ksrc|kcfg|kernel|boot|rootfs|image]
options:
    mkdirs              make skeletal build directory tree
    tools               show toolchain
    ksrc                show kernel source elements
    kcfg                configure kernel
    bldkrnl             build kernel
    pifw                get RaspPi boot partition firmware
    boot                build boot directory
    rootfs              build rootfs directory
    image               build dual-partition image
```

## Directory tree preparation 

## Cross-build toolchain

## Kernel configuration and build

### Configuration file

### Kernel build

### Modules

## Raspberry Pi firmware

## Boot partition

## Root filesystem

### Debootstrap phase 1

## microSD image

### Image creation

### Write to card

## Boot-up

### Debootstrap phase 2
