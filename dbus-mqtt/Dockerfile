FROM debian:buster-slim

ENV MQTT_BROKER_USER=
ENV MQTT_BROKER_PASS=
ENV MQTT_BROKER_HOST=127.0.0.1

RUN DEBIAN_FRONTEND=noninteractive apt update -qq && \
    apt install ca-certificates -qq -y && \
    echo "deb [trusted=yes] https://updates.victronenergy.com/feeds/venus/release/packages/debian-buster buster main" > /etc/apt/sources.list.d/victronenergy.list && \
    apt update -qq && \
    apt install dbus-mqtt libevent-2.1-6 libevent-pthreads-2.1-6 python3-dbus -qq -y && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/bin/entrypoint.sh

VOLUME /data

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
