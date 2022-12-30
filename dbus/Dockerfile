FROM arm32v7/debian:buster-slim

RUN DEBIAN_FRONTEND=noninteractive apt update -qq && \
    apt install dbus -qq -y && \
    rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
COPY ./victron.conf /etc/dbus-1/system.d/victron.conf

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
