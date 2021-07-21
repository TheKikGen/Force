#!/bin/sh

if test -f /etc/mockba_mod_installed; then
    echo "Already installed..."
else
    echo "Installing..."
    dev=`amidi -l | grep Private | cut -b5-13`
    cp -a /media/662522/Files/shadow /media/az01-internal/system/etc/overlay/
    sleep .5
    amidi -p $dev -S 'f0 47 00 40 65 00 04 08 20 00 00 f7'
    amidi -p $dev -S 'f0 47 00 40 65 00 04 09 05 00 00 f7'

    mkdir -p /media/az01-internal/system/etc/overlay/ssh
    cp -a /media/662522/Files/sshd_config /media/az01-internal/system/etc/overlay/ssh/
    sleep .5
    amidi -p $dev -S 'f0 47 00 40 65 00 04 09 20 00 00 f7'
    amidi -p $dev -S 'f0 47 00 40 65 00 04 0a 05 00 00 f7'

    cd /media/az01-internal/system
    tar xvf /media/662522/Files/usr.tar
    touch /media/662522/automount
    sleep .5
    amidi -p $dev -S 'f0 47 00 40 65 00 04 0a 20 00 00 f7'
    
    touch /etc/mockba_mod_installed

    reboot
fi
