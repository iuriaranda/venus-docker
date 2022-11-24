#!/bin/sh

mkdir -p /data/conf /data/db

echo "VRM portal ID: $(ip link ls dev eth0 | grep ether | awk '{print $2}' | sed 's/://g')"
echo

/opt/victronenergy/vrmlogger/vrmlogger.py
