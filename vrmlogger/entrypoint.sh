#!/bin/sh

mkdir -p /data/conf /data/db
sed -i 's+>900</LogInterval>+>60</LogInterval>+g' /data/conf/settings.xml
sed -i 's+>0</HasDcSystem>+>1</HasDcSystem>+g' /data/conf/settings.xml
mkdir -p /data/home /data/home/vnctunnel

echo "VRM portal ID: $(ip link ls dev eth0 | grep ether | awk '{print $2}' | sed 's/://g')"
echo

/opt/victronenergy/vrmlogger/vrmlogger.py
