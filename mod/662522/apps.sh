#!/bin/sh
cd /media/662522/Lua/
app=`luajit menu.lua`
if test "$app" == "MPC"; then
    cd /root/
    exec MPC "$@"
fi
if test "$app" == "MPCAuto"; then
    killall midiloop
    /media/662522/Tools/midiloop &
    sleep 1
    export ANYCTRL_NAME="Midiloop"
    export LD_PRELOAD="/media/662522/Libs/tkgl_anyctrl_lt.so"
    exec MPC "$@"
fi
if test "$app" == "TestApp"; then
    cd /usr/share/Akai/ADA2TestApp/
    exec ./ADA2TestApp
fi
if test "$app" == "Reboot"; then
    exec reboot
fi
if test "$app" == "Shutdown"; then
    exec shutdown
fi

cd /media/662522/Apps/
exec ./$app "$@"
