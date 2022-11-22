#!/bin/sh

mkdir -p /data/conf /data/db

ARGS=""
if [ ! -z "${MQTT_BROKER_USER}" ] && [ ! -z "${MQTT_BROKER_PASS}" ]; then
  ARGS="-u $MQTT_BROKER_USER -P $MQTT_BROKER_PASS"
fi

/opt/victronenergy/dbus-mqtt/dbus_mqtt.py -q $MQTT_BROKER_HOST $ARGS
