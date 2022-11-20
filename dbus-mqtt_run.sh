#!/bin/sh
echo "*** starting dbus-mqtt ***"
exec 2>&1
exec softlimit -d 100000000 -s 1000000 -a 100000000 /opt/victronenergy/dbus-mqtt/dbus_mqtt.py -q $MQTT_BROKER_HOST -u $MQTT_BROKER_USER -P $MQTT_BROKER_PASS
