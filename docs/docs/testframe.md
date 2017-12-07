# Test Framework

The notes below describe the test framework for the
Debian arm64 Raspberry Pi 3 system.

## Serial console output

Early console messages during bootup display on the HDMI monitor
with the Raspberry Pi logo. They can also be routed to a serial
line. If headless operation is contemplated, then is feature is
extremely useful, if not mandatory.  The serial console can be
accessed using a USB or RS232 to TTL serial cable plugged into
header pins of Raspberry Pi 3 board, specifically:
```text
        RPi3    Adafruit
        Pin     func    954 color
         4      5V      Red
         6      GND     Black
         8      TX      White
        10      RX      Green
```
           
The above colors are given for the Adafruit USB to TTL
serial cable (aka Adafruit 954, the number being the
product ID).
[https://www.adafruit.com/product/954](https://www.adafruit.com/product/954)
This cable is available through a number of outlets.

## microSD card

You will need a microSD card of at least 4 GB, and
preferably more (like 8 or 16 GB).
The microSD card will need to be divided into at least 2 partitions,
and possibly more.
(The `build.sh` script currently creates two partitions.)
Raspberry Pi uses the DOS Master Book Record (MBR) scheme for partitioning.
The `build.sh` build process follows the Raspbian layout, providing only
two partitions:

  - `boot` - FAT32 file system, around 100 MB
  - `rootfs` - Linux ext4 filesystem for the remainder of the 4 GB image

Only the first two above are mandatory;
however, if a larger microSD card is available, a swap space is recommended.
It is possible to later create a swapfile in the root filesystem.
However, a separate swap partition will be more efficient.

# More to come
