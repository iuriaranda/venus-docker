FROM arm32v7/node:18

RUN DEBIAN_FRONTEND=noninteractive apt update -y -qq && \
    apt install git -y -qq && \
    git clone https://github.com/victronenergy/venus-html5-app.git /opt/venus-html5-app && \
    cd /opt/venus-html5-app && \
    npm install

COPY entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
