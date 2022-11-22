FROM debian:buster-slim

RUN DEBIAN_FRONTEND=noninteractive apt update -qq && \
    apt install ca-certificates -qq -y && \
    echo "deb [trusted=yes] https://updates.victronenergy.com/feeds/venus/release/packages/debian-buster buster main" > /etc/apt/sources.list.d/victronenergy.list && \
    apt update -qq && \
    apt install localsettings -qq -y && \
    rm -rf /var/lib/apt/lists/*

VOLUME /data

COPY ./entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
