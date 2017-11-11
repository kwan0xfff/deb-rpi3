# deb-rpi3
Debian arm64 on Raspberry Pi 3 (ARM Cortex-A53)

VERY PRELIMINARY DRAFT

## Introduction

This is a set of tools and notes for building a Debian arm64 image for
Raspberry Pi 3.

The top-level directory structure is:
* `README.md` - this file
* `boot` subdir - bootloader configuration
* `docs` subdir - project documentation
* `kernel` subdir - Linux kernel configuration
* `rootfs` subdir - root filesystem configuration
* `build` subdir - build temporary work and final products

The current distributed binary is a zip file of the boot and rootfs
partitions, suitable for unzip onto a microSD card, and easy boot-up.
The binary zip file is about 680+ MB, and expands into a 4 GB image.

