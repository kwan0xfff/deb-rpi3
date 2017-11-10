#!/bin/sh
# build-kernel.sh

# build Linux kernel

do_showtools() {
    echo TCROOT is ${TCROOT}
    echo TCPFX is ${TCPFX}
    (   cd ${TCROOT}/bin
        ls ${TCPFX}*
    )
}

do_ksrc() {
    # show kernel source elements
    echo KSRC is ${KSRC}
    (   cd ${KSRC}
        git log -5 --oneline
    )
}

do_copyconfig() {
    # copy in kernel config
    cp ${CONFIG} ${KTRG}/.config
}

do_bldkrnl() {
    # build kernel
    echo KTRG is ${KTRG}
    (   cd ${KTRG}
        echo TCROOT $TCROOT
        PATH=${TCROOT}/bin:${PATH}
        nice -10 make ARCH=${ARCH} CROSS_COMPILE=${TCPFX} O=$PWD \
        -C ${KSRC} -j${NCPUS} Image modules
    )
}


# want enhanced getopt
getopt --test > /dev/null 
if [ $? -ne 4 ] ; then
    echo "sorry, getopt is incorrect version."
    exit 1
fi

OPTIONS=a:c:p:t:vj:
LONGOPTIONS=arch:,config:,tcpfx:,tcroot:,verbose,ncpus:

PARSED=$(getopt -o $OPTIONS -l $LONGOPTIONS --name "$0" -- "$@")

eval set -- "${PARSED}"

while true; do
    case "$1" in
        -a|--arch) ARCH=$2 ; shift 2 ;;
        -c|--config) CONFIG=$2 ; shift 2 ;;
        -p|--tcpfx) TCPFX=$2 ; shift 2 ;;
        -t|--tcroot) TCROOT=$2 ; shift 2 ;;
        -j|--ncpus) NCPUS=$2 ; shift 2 ;;
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
  tools)
    do_showtools
    ;;
  ksrc)
    KSRC=$1 ; shift
    do_ksrc
    ;;
  bldkrnl)
    set -x
    KSRC=$1 ; shift
    KTRG=$1 ; shift
    do_copyconfig
    do_bldkrnl
    ;;
  *)
    echo "Unknown subcommand:" ${subcmd}
    exit 1
    ;;
esac

exit 0

