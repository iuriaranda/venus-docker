#!/bin/sh

mkdir -p /data/conf /data/db
sed -i 's+>900</LogInterval>+>60</LogInterval>+g' /data/conf/settings.xml
sed -i 's+>0</HasDcSystem>+>1</HasDcSystem>+g' /data/conf/settings.xml
sed -i '/</Bol>/a \    \<MqttVrm type="i" min="0" max="1" default="0" silent="False">1</MqttVrm>' settings.xml
sed -i '/</Bol>/a \    \<MqttN2k type="i" min="0" max="1" default="0" silent="False">0</MqttN2k>' settings.xml
sed -i '/</Bol>/a \    \<MqttLocalInsecure type="i" min="0" max="1" default="0" silent="False">0</MqttLocalInsecure>' settings.xml
sed -i '/</Bol>/a \    \<MqttLocal type="i" min="0" max="1" default="0" silent="False">0</MqttLocal>' settings.xml

mkdir -p /data/home /data/home/vnctunnel

echo "VRM portal ID: $(ip link ls dev eth0 | grep ether | awk '{print $2}' | sed 's/://g')"
echo

/opt/victronenergy/vrmlogger/vrmlogger.py
