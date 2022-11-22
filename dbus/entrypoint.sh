#!/bin/sh

mkdir -p /var/run/dbus/

/usr/bin/dbus-daemon --config-file=/etc/dbus-1/system.d/victron.conf
