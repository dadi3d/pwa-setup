FROM nginx:alpine

# Kopiere die nginx Konfiguration
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Erstelle die notwendigen Verzeichnisse
RUN mkdir -p /etc/nginx/ssl && \
    mkdir -p /var/cache/nginx/imgproxy && \
    chown -R nginx:nginx /var/cache/nginx

# Exponiere die Ports
EXPOSE 80 443

# Starte nginx im Vordergrund
CMD ["nginx", "-g", "daemon off;"]