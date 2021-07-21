#!/bin/sh

# Get the keypad MIDI device and initialize it
dev=`amidi -l | grep Private | cut -b5-13`
amidi -p $dev -S 'f0 47 00 40 62 00 01 02 f7'

sync ; sync
cd /media/662522

# Execute OTA upgrade if exists
if test -f ./Updates/mockba.img; then
    . ./update.sh
fi

if test -f /tmp/mod_started; then
	echo "Already started"
else
    # Start logo video
    ./Tools/ffmpeg -i ./Videos/logo.mp4 -pix_fmt bgra -f fbdev /dev/fb0 </dev/null 2>/dev/null &
    sleep 2
    amidi -p $dev -S 'f0 47 00 40 65 00 04 00 00 20 20 f7'
    amidi -p $dev -S 'f0 47 00 40 65 00 04 01 00 05 05 f7'
    
    # Mount the /usr overlay
    f="/media/662522/overlay.sh"
    [ -f "$f" ] && "$f"
    sleep 1
    amidi -p $dev -S 'f0 47 00 40 65 00 04 01 00 20 20 f7'
    amidi -p $dev -S 'f0 47 00 40 65 00 04 02 00 05 05 f7'
    
    # Enable SSHD
    systemctl enable sshd
    sleep 1
    amidi -p $dev -S 'f0 47 00 40 65 00 04 02 00 20 20 f7'
    amidi -p $dev -S 'f0 47 00 40 65 00 04 03 00 05 05 f7'
    
    # Restart SSHD
    systemctl restart sshd
    sleep 1
    amidi -p $dev -S 'f0 47 00 40 65 00 04 03 00 20 20 f7'
    amidi -p $dev -S 'f0 47 00 40 65 00 04 04 00 05 05 f7'
    
    # Checks and runs runonce.sh
    f="/media/662522/runonce.sh"
    [ -f "$f" ] && "$f"
    rm -f "$f"
    sleep 1
    amidi -p $dev -S 'f0 47 00 40 65 00 04 04 00 20 20 f7'
    amidi -p $dev -S 'f0 47 00 40 65 00 04 05 00 05 05 f7'
    
    # Checks and runs autoexec.sh
    f="/media/662522/autoexec.sh"
    [ -f "$f" ] && "$f"
    sleep 1
    amidi -p $dev -S 'f0 47 00 40 65 00 04 05 00 20 20 f7'
    amidi -p $dev -S 'f0 47 00 40 65 00 04 06 00 05 05 f7'
    
    # Waits for ffmpeg to finish
    while [ `ps | grep ffmpeg | wc -l` -gt 1 ]
    do
        echo "ffmpeg is running"
        sleep .2	
    done
    
    # First installation script
    amidi -p $dev -S 'f0 47 00 40 65 00 04 06 00 20 20 f7'
    amidi -p $dev -S 'f0 47 00 40 65 00 04 07 00 05 05 f7'
    f="/media/662522/install.sh"
    [ -f "$f" ] && "$f"

    touch /tmp/mod_started
    amidi -p $dev -S 'f0 47 00 40 65 00 04 07 00 20 20 f7'
fi

# Starts MPC
ulimit -S -s 1024
if test -f /usr/bin/luajit; then
    if test -f /media/662522/apps.sh; then
        /media/662522/apps.sh
    else
        exec /usr/bin/MPC "$@"
    fi
else
    exec /usr/bin/MPC "$@"
fi
