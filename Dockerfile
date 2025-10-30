FROM nginx:alpine

# Kopiere die nginx Konfiguration als Template
COPY nginx/nginx.conf /etc/nginx/nginx.conf.template

# Kopiere das Entrypoint-Script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Erstelle die notwendigen Verzeichnisse
RUN mkdir -p /etc/nginx/ssl && \
    mkdir -p /var/cache/nginx/imgproxy && \
    chown -R nginx:nginx /var/cache/nginx

# Exponiere die Ports
EXPOSE 80 443

# Verwende das Entrypoint-Script
ENTRYPOINT ["/docker-entrypoint.sh"]