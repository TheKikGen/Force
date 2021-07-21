#!/bin/sh
if test -f /media/662522/automount; then
	mkdir -p /media/az01-internal/system/usr/
	mkdir -p /media/az01-internal/system/usr/overlay/
	mkdir -p /media/az01-internal/system/usr/.work/
	mount -t overlay -o rw,relatime,lowerdir=/usr,upperdir=/media/az01-internal/system/usr/overlay,workdir=/media/az01-internal/system/usr/.work overlay /usr
else
	echo "Overlay not mounted."
fi
