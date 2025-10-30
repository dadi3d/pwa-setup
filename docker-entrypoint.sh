#!/bin/sh
set -e

# Setze Default-Wert für IMGPROXY_PORT falls nicht gesetzt
IMGPROXY_PORT=${IMGPROXY_PORT:-8080}

echo "Configuring nginx with IMGPROXY_PORT=${IMGPROXY_PORT}"

# Ersetze den Platzhalter in der nginx-Konfiguration
sed "s/\${IMGPROXY_PORT}/${IMGPROXY_PORT}/g" /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Starte nginx
exec nginx -g "daemon off;"
