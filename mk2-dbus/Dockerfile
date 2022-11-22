FROM debian:buster-slim

ENV MK3DEV=/dev/ttyMK3

RUN DEBIAN_FRONTEND=noninteractive apt update -qq && \
    apt install ca-certificates -qq -y && \
    echo "deb [trusted=yes] https://updates.victronenergy.com/feeds/venus/release/packages/debian-buster buster main" > /etc/apt/sources.list.d/victronenergy.list && \
    apt update -qq && \
    apt install mk2-dbus libevent-2.1-6 libdbus-1-3 -qq -y && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/bin/entrypoint.sh

VOLUME /data

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
