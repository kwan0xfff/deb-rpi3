#!/bin/sh
# build-image.sh

# Construct media image for Raspberry Pi 3

IMGSZ=4096      # total image filesize
BOOTSZ=256      # boot partition size

do_imgskel() {
    # create empty image
    dd if=/dev/zero of=${IMGF} bs=1M count=${IMGSZ} \
        status=progress

    part1end=$(expr 2048 \* ${BOOTSZ} - 1)
    part2end=$(expr 2048 \* ${IMGSZ} - 1)
    #echo part1end $part1end
    #echo part2end $part2end
    part1="n\np\n1\n\n${part1end}\n"
    part2="n\np\n2\n\n${part2end}\n"
    types="t\n1\nc\nt\n2\n83\n"

    full="o\n${part1}${part2}${types}\nw\nq"
    echo $full | fdisk ${IMGF}
}


# want enhanced getopt
getopt --test > /dev/null 
if [ $? -ne 4 ] ; then
    echo "sorry, getopt is incorrect version."
    exit 1
fi

OPTIONS=v
LONGOPTIONS=imgsz:,rootsz:,verbose


PARSED=$(getopt -o $OPTIONS -l $LONGOPTIONS --name "$0" -- "$@")

eval set -- "${PARSED}"

while true; do
    case "$1" in
        --imgsz) IMGSZ=$2 ; shift ;;
        --bootsz) BOOTSZ=$2 ; shift ;;
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
  image)
    IMGF=$1 ; shift     # image file
    do_imgskel
    ;;
  *)
    echo "Unknown subcommand:" ${subcmd}
    exit 1
    ;;
esac

exit 0

