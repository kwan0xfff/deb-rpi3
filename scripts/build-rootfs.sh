#!/bin/sh
# build-rootfs.sh

# Construct Debian-based root filesystem image for
# Raspberry Pi 3.
# Currently, only executes debootstrap stage 1

# basic values
RELEASE=${RELEASE=stretch}
ARCH=${ARCH=arm64}
REPO=http://ftp.us.debian.org/debian

# packages
PKGINCL=build-essential,gcc-6,gdb,e17,wicd

# CROSSPATH=/opt/linaro/gcc-linaro-aarch64
# PATH=${CROSSPATH}/bin:${PATH}

# 'build' directory tree
do_rootfs() {
    # Do debootstrap as root
    (   cd ${RTRG}
        debootstrap --arch=${ARCH} \
            --include=${PKGINCL} --foreign ${RELEASE} \
            $(pwd) ${REPO}
    )
}

# want enhanced getopt
getopt --test > /dev/null 
if [ $? -ne 4 ] ; then
    echo "sorry, getopt is incorrect version."
    exit 1
fi

OPTIONS=a:p:i:r:R:t:v
LONGOPTIONS=arch:,tcpfx:,pkgincl:,release:,tcroot:,verbose

PARSED=$(getopt -o $OPTIONS -l $LONGOPTIONS --name "$0" -- "$@")

eval set -- "${PARSED}"

while true; do
    case "$1" in
        -a|--arch) ARCH=$2 ; shift 2 ;;
        -p|--tcpfx) TCPFX=$2 ; shift 2 ;;
        -i|--pkgincl) PKGINCL=$2 ; shift 2 ;;
        -r|--repo) REPO=$2 ; shift 2 ;;
        -R|--release) RELEASE=$2 ; shift 2 ;;
        -t|--tcroot) TCROOT=$2 ; shift 2 ;;
        -v|--verbose) VERBOSE=true ; shift ;;
        --) shift ; break ;;
        *) echo "Internal error\!"; exit 1 ;;
    esac
done

echo remaining:  $*

# Process positional arguments

subcmd=$1
shift

echo subcommand: ${subcmd}
echo remaining:  $*

case ${subcmd} in
  rootfs)
    RTRG=$1 ; shift
    do_rootfs
    ;;
  *)
    echo "Unknown subcommand:" ${subcmd}
    exit 1
    ;;
esac

exit 0

