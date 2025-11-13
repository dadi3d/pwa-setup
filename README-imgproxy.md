# Nginx + imgproxy Integration

Diese Konfiguration integriert imgproxy für die Bildkonvertierung und -optimierung in das nginx-Setup.

## Konfiguration

### nginx.conf Änderungen

1. **Cache-Verzeichnis**: `/var/cache/nginx/imgproxy` für gecachte Bilder
2. **Upstream**: `imgproxy` auf Port 5175 im "ausleihe" Netzwerk
3. **Location `/images/`**: Hauptendpunkt für Bildkonvertierung
4. **Location `/api/files/`**: Fallback für direkte Bildauslieferung

### imgproxy URL-Format

Bilder können über folgende URLs angefordert werden:

```
https://medienausleihe.oth-aw.de/images/<imgproxy-params>
```

#### Beispiel-URLs:

**Resize auf 300x200:**
```
/images/resize:fill:300:200/plain/https://medienausleihe.oth-aw.de/api/files/images/beispiel.jpg
```

**WebP-Konvertierung:**
```
/images/format:webp/plain/https://medienausleihe.oth-aw.de/api/files/images/beispiel.jpg
```

**Kombiniert (Resize + WebP):**
```
/images/resize:fill:300:200/format:webp/plain/https://medienausleihe.oth-aw.de/api/files/images/beispiel.jpg
```

## Cache-Verhalten

- **Erfolgreiche Konvertierungen**: 7 Tage gecacht
- **404-Fehler**: 1 Minute gecacht
- **Cache-Headers**: `Cache-Control: public, max-age=604800`
- **Cache-Status**: Wird über `X-Cache-Status` Header angezeigt

## imgproxy Docker-Konfiguration (Komodo)

Folgende Umgebungsvariablen sollten in Komodo für den imgproxy-Container gesetzt werden:

```bash
# Sicherheit
IMGPROXY_KEY=<secret-key>
IMGPROXY_SALT=<secret-salt>

# Performance
IMGPROXY_MAX_SRC_RESOLUTION=16
IMGPROXY_JPEG_PROGRESSIVE=true
IMGPROXY_PNG_INTERLACED=true

# Formate
IMGPROXY_ENABLE_WEBP_DETECTION=true
IMGPROXY_ENFORCE_WEBP=false

# Sicherheit - nur bestimmte Domains erlauben
IMGPROXY_ALLOWED_SOURCES=https://medienausleihe.oth-aw.de

# Timeouts
IMGPROXY_READ_TIMEOUT=10
IMGPROXY_WRITE_TIMEOUT=10
IMGPROXY_DOWNLOAD_TIMEOUT=10

# Logging
IMGPROXY_LOG_LEVEL=warn
```

## Frontend-Integration

Im Frontend können Sie die Bildoptimierung wie folgt nutzen:

```javascript
// Automatische WebP-Erkennung und Resize
function getOptimizedImageUrl(originalUrl, width = 300, height = 200) {
    const baseUrl = '/images';
    const params = `resize:fill:${width}:${height}/format:webp`;
    return `${baseUrl}/${params}/plain/${originalUrl}`;
}

// Verwendung
const optimizedUrl = getOptimizedImageUrl(
    'https://medienausleihe.oth-aw.de/api/files/images/product123.jpg',
    400,
    300
);
```

## Monitoring

- Cache-Status über `X-Cache-Status` Header prüfen:
  - `HIT`: Aus Cache geliefert
  - `MISS`: Neu konvertiert
  - `STALE`: Veraltete Version aus Cache

## Troubleshooting

1. **Cache leeren**: `docker exec nginx rm -rf /var/cache/nginx/imgproxy/*`
2. **Logs prüfen**: `docker logs nginx` und `docker logs imgproxy`
3. **Netzwerk testen**: Sicherstellen, dass nginx und imgproxy im gleichen Docker-Netzwerk "ausleihe" sind