#!/bin/sh
echo "*** starting mk2-dbus ***"
exec 2>&1
exec softlimit -d 100000000 -s 1000000 -a 100000000 /opt/victronenergy/mk2-dbus/mk2-dbus --log-before 25 --log-after 25 --banner -w -s $MK3DEV -t mk3 --settings /data/var/lib/mk2-dbus/mkxport-$(basename $MK2DEV).settings
