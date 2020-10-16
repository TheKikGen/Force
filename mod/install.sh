#!/bin/sh

if test -f /media/az01-internal/system/etc/overlay/installed; then
    echo "Already installed"
else
    echo "Installing"
    dev=`amidi -l | grep Private | cut -b5-13`
    cp -a /usr/share/Mockba/shadow /media/az01-internal/system/etc/overlay/
    sleep .5
    amidi -p $dev -S 'f0 47 00 40 65 00 04 08 20 00 00 f7'

    mkdir -p /media/az01-internal/system/etc/overlay/ssh
    cp -a /usr/share/Mockba/sshd_config /media/az01-internal/system/etc/overlay/ssh/
    sleep .5
    amidi -p $dev -S 'f0 47 00 40 65 00 04 09 20 00 00 f7'

    mkdir -p /media/az01-internal-sd/Force\ Documents/Arp\ Patterns
    cp -a /usr/share/Akai/SME0/Arp\ Patterns\ Old/* /media/az01-internal-sd/Force\ Documents/Arp\ Patterns/
    sleep .5
    amidi -p $dev -S 'f0 47 00 40 65 00 04 0a 20 00 00 f7'
    
    touch /media/az01-internal/system/etc/overlay/installed
fi
