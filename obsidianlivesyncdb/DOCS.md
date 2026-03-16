# My Home Assistant App: Obsidian LiveSync DB

## Installation

TBD

Activate *WebSocket support* and *HTTP/2* in NGINX Proxy Manager

Configure the following advanced configuration in NGINX Proxy Manager

```
# Aumentar el tamaño máximo de subida para notas con adjuntos grandes
client_max_body_size 0; # El 0 desactiva el límite en NGINX, mandan los 4GB de CouchDB

# Optimización para conexiones largas (necesario para el feed de cambios de CouchDB)
proxy_read_timeout 3600s;
proxy_send_timeout 3600s;
proxy_connect_timeout 3600s;

# Configuración de Buffering
# Se desactiva para que la sincronización en tiempo real sea instantánea
proxy_buffering off;
proxy_request_buffering off;
```

Access `/_utils` to check the couchdb web console

Now you are ready to configure the plugin in the obsidian application

## Configuration

TBD

https://github.com/vrtmrz/obsidian-livesync/blob/main/docs/setup_own_server.md