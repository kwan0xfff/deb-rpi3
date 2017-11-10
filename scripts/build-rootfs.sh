#!/bin/sh

#
# build-rootfs.sh
#
# Construct Debian-based root filesystem image for Raspberry Pi 3
# Currently, only executes debootstrap stage 1

# basic values
RTFS_RELEASE=${RTFS_RELEASE=stretch}
RTFS_ARCH=${RTFS_ARCH=arm64}
KRNL_ARCH=${KRNL_ARCH=aarch64}
REPO_HOST=http://ftp.us.debian.org/debian

# packages
PKG_INCL=build-essential,gcc-6,gdb,e17,wicd

# derived values
CROSSGCC=${KRNL_ARCH}-linux-gnu-gcc
CROSSPATH=/opt/linaro/gcc-linaro-aarch64
PATH=${CROSSPATH}/bin:${PATH}

# 'build' directory tree
BLDDIR=${BLDDIR=$(pwd)/build}

if [ ! -d "${BLDDIR}" ]; then
    mkdir ${BLDDIR}
    mkdir ${BLDDIR}/kernel
    mkdir ${BLDDIR}/rootfs
fi

# check compiler
${CROSSGCC} --version 2>&1 > /dev/null
#echo got $?

if [ $? = 0 ]; then
    echo ${CROSSGCC} found in PATH
else
    echo cannot find ${CROSSGCC} in PATH
    exit 1
fi

# Do debootstrap as root
cd ${BLDDIR}/rootfs
debootstrap --arch=${RTFS_ARCH} --include=${PKG_INCL} --foreign ${RTFS_RELEASE} \
    $(pwd) ${REPO_HOST}

