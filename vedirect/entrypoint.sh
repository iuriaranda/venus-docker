#!/bin/sh

mkdir -p /data/conf /data/db

/opt/victronenergy/vedirect-interface/vedirect-dbus -v --log-before 25 --log-after 25 -t30 --banner -s $VEDIRECTDEV --dbus-instance $VEDIRECTDBUSINSTANCE
