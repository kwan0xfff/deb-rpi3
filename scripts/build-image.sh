#!/bin/sh
# build-image.sh

# Construct media image for Raspberry Pi 3

# sizes, offsets in MB (1,048,576 bytes)
PSTART=1        # partitions start in MBR map
IMGSZ=4096      # total image filesize
BOOTSZ=255      # boot partition size

notimpl() {
    echo not yet implemented.
}

do_imgskel() {
    # create empty image
    dd if=/dev/zero of=${IMGF} bs=1M count=${IMGSZ} \
        status=progress

    part1end=$(expr 2048 \* \( ${BOOTSZ} + ${PSTART} \) - 1 )
    part2end=$(expr 2048 \* ${IMGSZ} - 1)
    #echo part1end $part1end
    #echo part2end $part2end
    part1="n\np\n1\n\n${part1end}\n"
    part2="n\np\n2\n\n${part2end}\n"
    types="t\n1\nc\nt\n2\n83\n"

    full="o\n${part1}${part2}${types}\nw\nq"
    echo $full | fdisk ${IMGF}
    (   D=$(dirname ${IMGF}); B=$(basename ${IMGF});
        cd ${D}; fdisk ${B} -l
    )
}

do_loopsetup() {
    part1st=${PSTART}
    part2st=$(expr ${BOOTSZ} + ${PSTART} )
    part1sz=${BOOTSZ}
    part2sz=$(expr ${IMGSZ} - ${BOOTSZ} - 1 )
    #echo part1st $part1st
    #echo part2st $part2st
    #echo part1sz $part1sz
    #echo part2sz $part2sz

    losetup -o ${part1st}M --sizelimit ${part1sz}M /dev/loop1 ${IMGF}
    losetup -o ${part2st}M --sizelimit ${part2sz}M /dev/loop2 ${IMGF}
}

do_loopteardown() {
    losetup -d /dev/loop2
    losetup -d /dev/loop1
}

do_partfmts() {
    mkfs.vfat -F32 -n boot /dev/loop1
    mkfs.ext4 -L rootfs /dev/loop2
}

do_mkboot() {
    MOUNTPT=${BLDDIR}/mnt
    [ -d ${MOUNTPT} ] || ${MOUNTPT}
    mount /dev/loop1 ${MOUNTPT}
    # do boot partition build here
    umount ${MOUNTPT}
}

# want enhanced getopt
getopt --test > /dev/null 
if [ $? -ne 4 ] ; then
    echo "sorry, getopt is incorrect version."
    exit 1
fi

OPTIONS=v
LONGOPTIONS=imgsz:,rootsz:,blddir:,verbose


PARSED=$(getopt -o $OPTIONS -l $LONGOPTIONS --name "$0" -- "$@")

eval set -- "${PARSED}"

while true; do
    case "$1" in
        --imgsz) IMGSZ=$2 ; shift 2 ;;
        --bootsz) BOOTSZ=$2 ; shift 2 ;;
        --blddir) BLDDIR=$2 ; shift 2 ;;
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
  imgskel)
    IMGF=$1 ; shift     # image file
    do_imgskel
    ;;
  partfmts)
    IMGF=$1 ; shift     # image file
    do_loopsetup
    do_partfmts
    do_loopteardown
    ;;
  mkboot)
    notimpl
    #do_loopsetup
    #do_mkboot
    #do_loopteardown
    ;;
  mkrootfs)
    notimpl
    ;;
  *)
    echo "Unknown subcommand:" ${subcmd}
    exit 1
    ;;
esac

exit 0

