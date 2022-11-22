#!/bin/sh
echo "*** starting vedirect-interface ***"
exec 2>&1
exec /opt/victronenergy/vedirect-interface/vedirect-dbus -v --log-before 25 --log-after 25 -t30 --banner -s $VEDIRECTDEV --dbus-instance $VEDIRECTDBUSINSTANCE
