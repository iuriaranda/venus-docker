#!/bin/sh

mkdir -p /data/conf /data/db
mkdir -p /data/var/lib/mk2-dbus

cp -R /opt/victronenergy/service-templates/mk2-dbus /etc/service/mk2-dbus
cp -R /opt/victronenergy/service-templates/vedirect-interface /etc/service/vedirect
cp -R /opt/victronenergy/service-templates/dbus-mqtt /etc/service/dbus-mqtt

cat /opt/victronenergy/service-templates/mk2-dbus/run | envsubst > /etc/service/mk2-dbus/run
cat /opt/victronenergy/service-templates/vedirect-interface/run | envsubst > /etc/service/vedirect/run
cat /opt/victronenergy/service-templates/dbus-mqtt/run | envsubst > /etc/service/dbus-mqtt/run

rm -rf /etc/service/mk2-dbus/down \
       /etc/service/mk2-dbus/log/down \
       /etc/service/vedirect/down \
       /etc/service/vedirect/log/down \
       /etc/service/dbus-mqtt/down \
       /etc/service/dbus-mqtt/log/down

/usr/bin/svscanboot
