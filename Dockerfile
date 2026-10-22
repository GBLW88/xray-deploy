FROM alpine:3.20
RUN apk add --no-cache ca-certificates curl unzip \
 && XRAY_VER=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep '"tag_name"' | cut -d'"' -f4) \
 && curl -sL "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VER}/Xray-linux-64.zip" -o /tmp/xray.zip \
 && unzip -o /tmp/xray.zip -d /usr/local/bin xray \
 && chmod +x /usr/local/bin/xray \
 && rm /tmp/xray.zip
COPY entrypoint.sh /entrypoint.sh
COPY config.edge.json /config.edge.json
COPY config.direct.json /config.direct.json
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
