#!/bin/sh
#  build.sh

#
# Build bootable 64-bit image for Raspberry Pi 3.
#

if [ ! -f build.cfg ]; then
    echo Missing build.cfg file.
    exit 1
fi

BLDDIR=${BLDDIR=$(pwd)/build}

notimpl() {
    echo not yet implemented.
}

make_blddirs() {
    if [ ! -d "${BLDDIR}" ]; then
        mkdir ${BLDDIR}
        mkdir ${BLDDIR}/kernel
        mkdir ${BLDDIR}/rootfs
    else
        echo Build directory ${BLDDIR} is in place.
    fi  
}


. ./build.cfg   # read build configuration parameters

case "$1" in
  mkdirs)
    make_blddirs ;;
  tools)
    scripts/build-kernel.sh tools -t $TCROOT -p $TCPFX
    ;;
  ksrc)
    scripts/build-kernel.sh ksrc $KSRC
    ;;
  kcfg)
    scripts/build-kernel.sh kcfg \
        -a $ARCH -t $TCROOT -p $TCPFX -c ${PWD}/kernel/config \
        $KSRC $BLDDIR/kernel
    ;;
  bldkrnl)
    scripts/build-kernel.sh bldkrnl \
        -a $ARCH -t $TCROOT -p $TCPFX -c ${PWD}/kernel/config -j$NCPUS \
        $KSRC $BLDDIR/kernel
    ;;
  boot)         notimpl ;;
  rootfs)
    scripts/build-rootfs.sh rootfs $BLDDIR/rootfs
    ;;
  image)        notimpl ;;
  *)  # default case; unrecognized option
    cat << EndOfFile
syntax: build.sh [mkdirs|tools|ksrc|kcfg|kernel|boot|rootfs|image]
options:
    mkdirs              make skeletal build directory tree
    tools               show toolchain
    ksrc                show kernel source elements
    kcfg                configure kernel
    bldkrnl             build kernel
    boot                build boot directory
    rootfs              build rootfs directory
    image               build dual-partition image
EndOfFile
    ;;
esac
