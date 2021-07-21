#!/bin/sh

# OTA Firmware Update
header=$( head -c4 ./Updates/mockba.img | tr "\0" "a" )
if [ "$header" = "aaaa" ]; then
    echo "Valid image"
    amidi -p $dev -S 'f0 47 00 40 65 00 04 00 20 20 00 f7'
    dd if=./Images/update.bgra of=/dev/fb0 bs=131072
    amidi -p $dev -S 'f0 47 00 40 65 00 04 01 20 20 00 f7'
    dd if=./Updates/mockba.img of=/dev/disk/by-partlabel/rootfs bs=1
    amidi -p $dev -S 'f0 47 00 40 65 00 04 02 20 20 00 f7'
    mv ./Updates/mockba.img ./Updates/mockba.applied
    amidi -p $dev -S 'f0 47 00 40 65 00 04 03 20 20 00 f7'
    dd if=./Images/reboot.bgra of=/dev/fb0 bs=131072
    amidi -p $dev -S 'f0 47 00 40 65 00 04 04 20 20 00 f7'
    ./Tools/reboot
else
    amidi -p $dev -S 'f0 47 00 40 65 00 04 00 20 00 00 f7'
    dd if=./Images/update.bgra of=/dev/fb0 bs=131072
    amidi -p $dev -S 'f0 47 00 40 65 00 04 01 20 00 00 f7'
    mv ./Updates/mockba.img ./Updates/mockba.invalid
    amidi -p $dev -S 'f0 47 00 40 65 00 04 02 20 00 00 f7'
    dd if=./Images/reboot.bgra of=/dev/fb0 bs=131072
    amidi -p $dev -S 'f0 47 00 40 65 00 04 03 20 00 00 f7'
    ./Tools/reboot
fi
