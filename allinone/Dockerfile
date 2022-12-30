FROM arm32v7/debian:buster-slim

ENV MQTT_BROKER_USER=mqtt
ENV MQTT_BROKER_PASS=foo
ENV MQTT_BROKER_HOST=127.0.0.1
ENV VEDIRECTDEV=/dev/ttyVEDirect
ENV VEDIRECTDBUSINSTANCE=0
ENV MK3DEV=/dev/ttyMK3

RUN DEBIAN_FRONTEND=noninteractive apt update -qq && \
    apt install ca-certificates -qq -y && \
    echo "deb [trusted=yes] https://updates.victronenergy.com/feeds/venus/release/packages/debian-buster buster main" > /etc/apt/sources.list.d/victronenergy.list && \
    apt update -qq && \
    apt install localsettings mk2-dbus dbus-mqtt vedirect-interface libevent-2.1-6 libevent-pthreads-2.1-6 gettext-base -qq -y

COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY mk2-dbus_run.sh /opt/victronenergy/service-templates/mk2-dbus/run
COPY vedirect_run.sh /opt/victronenergy/service-templates/vedirect-interface/run
COPY dbus-mqtt_run.sh /opt/victronenergy/service-templates/dbus-mqtt/run

VOLUME /data

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
