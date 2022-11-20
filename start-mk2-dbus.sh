#!/bin/sh

tty=$1
base=$(dirname $0)
settings="/data/var/lib/mk2-dbus/mkxport-${tty}.settings"
mkdir -p $(dirname $settings)

$base/mk2-dbus --log-before 25 --log-after 25 --banner -w -s /dev/$tty -t mk3 --settings $settings
