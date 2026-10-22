#!/bin/sh
# Renders the xray config from env vars and starts xray.
# Env: UUID (required), WS_PATH (default /vless), PORT (default 8080),
#      TLS_MODE=edge|direct (default edge),
#      TLS_CERT / TLS_KEY (direct mode only, default /etc/xray-cert/*.pem)
set -e
: "${UUID:?env UUID is required}"
: "${WS_PATH:=/vless}"
: "${PORT:=8080}"
: "${TLS_MODE:=edge}"

if [ "$TLS_MODE" = "direct" ]; then
  : "${TLS_CERT:=/etc/xray-cert/fullchain.pem}"
  : "${TLS_KEY:=/etc/xray-cert/privkey.pem}"
  TEMPLATE=/config.direct.json
else
  TEMPLATE=/config.edge.json
fi

sed -e "s|__UUID__|${UUID}|g" \
    -e "s|__WS_PATH__|${WS_PATH}|g" \
    -e "s|__PORT__|${PORT}|g" \
    -e "s|__TLS_CERT__|${TLS_CERT:-}|g" \
    -e "s|__TLS_KEY__|${TLS_KEY:-}|g" \
    "$TEMPLATE" > /etc/xray-config.json

exec /usr/local/bin/xray run -c /etc/xray-config.json
