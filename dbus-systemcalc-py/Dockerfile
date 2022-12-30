FROM arm32v7/debian:bullseye-slim
# we need bullseye for this one since it's only compatible with python-3.8 and up

RUN DEBIAN_FRONTEND=noninteractive apt update -qq && \
    apt install ca-certificates -qq -y && \
    echo "deb [trusted=yes] https://updates.victronenergy.com/feeds/venus/release/packages/debian-buster buster main" > /etc/apt/sources.list.d/victronenergy.list && \
    apt update -qq && \
    apt install dbus-systemcalc-py -qq -y && \
    rm -rf /var/lib/apt/lists/*

VOLUME /data

COPY ./entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
