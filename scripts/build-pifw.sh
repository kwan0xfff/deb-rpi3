#!/bin/sh
# build-pifw.sh

# Construct boot partition for Raspberry Pi 3.

# basic values
PIFWREPO=https://github.com/raspberrypi/firmware.git

# get Pi boot partition firmware
do_fetch() {
    # do a sparse checkout of Pi firmware repo boot directory
    echo NOTE: Pi firmware checkout from repo fetches over 8 GB of disk space
    echo for objects before checkout.
    echo Cancel in 10 seconds, if you do not want to do this.
    sleep 5
    for n in 5 4 3 2 1; do
      echo -n $n"... "
      sleep 1
    done
    echo
    echo fwdir $FWDIR
    if [ -d ${FWDIR}/.git ]; then
        (   cd ${FWDIR}; git pull origin master )
    else
        (   cd ${FWDIR}
            git init
            git remote add -f origin ${PIFWREPO}
            git config core.sparseCheckout true
            echo boot >> .git/info/sparse-checkout
            echo extra >> .git/info/sparse-checkout
            echo git pull --depth=4 origin master
        )
    fi
}

# create firmware tarball
do_tarcreate() {
    PIFWTAR=$1
    (   cd ${FWDIR}
        tar czvf ${PIFWTAR} ./boot
        echo == ${PIFWTAR} written in ${FWDIR} ==
    )
    echo To really use this firmware,
    echo replace ${PIFWTAR} in project source \'boot\' directory.
}

# want enhanced getopt
getopt --test > /dev/null 
if [ $? -ne 4 ] ; then
    echo "sorry, getopt is incorrect version."
    exit 1
fi

OPTIONS=nv
LONGOPTIONS=noop,verbose

PARSED=$(getopt -o $OPTIONS -l $LONGOPTIONS --name "$0" -- "$@")

eval set -- "${PARSED}"

while true; do
    case "$1" in
        -v|--verbose) VERBOSE=true ; shift ;;
        -n|--noop) NOOP=true ; shift ;;
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

if [ "$NOOP" ]; then
    echo Show this script can be invoked.
    echo No operation, no subcommand parse.
    exit 0
fi

case ${subcmd} in
  fetch)         # Pi firmware sparse checkout
    FWDIR=$1 ; shift
    do_fetch
    ;;
  tarcreate)
    FWDIR=$1 ; shift
    do_tarcreate boot.tar.gz
    ;;
  *)
    echo "Unknown subcommand:" ${subcmd}
    exit 1
    ;;
esac

exit 0

