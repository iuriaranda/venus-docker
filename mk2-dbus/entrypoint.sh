#!/bin/sh

mkdir -p /data/conf /data/db
mkdir -p /data/var/lib/mk2-dbus

/opt/victronenergy/mk2-dbus/mk2-dbus --log-before 25 --log-after 25 --banner -w -s $MK3DEV -t mk3 --settings /data/var/lib/mk2-dbus/mkxport-$(basename $MK3DEV).settings
