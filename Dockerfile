FROM nginx:alpine

# Kopiere die nginx Konfiguration
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Erstelle das SSL-Verzeichnis im Container
RUN mkdir -p /etc/nginx/ssl

# Exponiere die Ports
EXPOSE 80 443

# Starte nginx im Vordergrund
CMD ["nginx", "-g", "daemon off;"]