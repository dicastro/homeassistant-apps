# My Home Assistant App: Obsidian LiveSync DB

## Installation

TBD

Check for this line in logs

```
[Wrapper] Obsidian LiveSync configuration applied successfully
```

Activate *WebSocket support* and *HTTP/2* in NGINX Proxy Manager

Configure the following advanced configuration in NGINX Proxy Manager

```
# Increase maximum upload size for notes with large attachments
client_max_body_size 0; # 0 disables the limit in NGINX; CouchDB's 4GB limit takes precedence

# Optimization for long-lived connections (required for CouchDB's changes feed)
proxy_read_timeout 3600s;
proxy_send_timeout 3600s;
proxy_connect_timeout 3600s;

# Buffering Configuration
# Disabled to ensure near-instant real-time synchronization
proxy_buffering off;
proxy_request_buffering off;
```

Access `/_utils` to check the couchdb web console

Now you are ready to configure the plugin in the obsidian application

## Configuration

TBD

https://github.com/vrtmrz/obsidian-livesync/blob/main/docs/setup_own_server.md