# Documentation: Obsidian LiveSync DB

This application provides a CouchDB server optimized for the Obsidian Self-hosted LiveSync plugin.

## Configuration

**Note**: _Remember to restart the app when the configuration is changed._

Example app configuration:

```yaml
user: "obsidianlivesync"
password: "changeme"
verbose_initialization: "false"
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `user`

The admin username for CouchDB

### Option: `password`

The admin password (keep it secure)

### Option: `verbose_initialization`

Enable detailed logs during the startup/tuning process

## 🛠 Administration Console (Fauxton)

CouchDB includes a built-in web interface called **Fauxton** for database management.

You can access it at: `http://<YOUR_HOME_ASSISTANT_IP>:5984/_utils/`

**Note:** Use the credentials defined in your configuration tab to log in

## 🌐 Recommended Proxy Configuration

To sync your vault from outside your home network, you should expose this app through a proxy like NGINX Proxy Manager or similar.

| Configuration      | Value                                                    |
|:-------------------|:---------------------------------------------------------|
| Domain Name        | `obsidianlivesyncdb.<YOUR_DOMAIN>`                       |
| Scheme             | `http`                                                   |
| Forward Hostname   | `1da1ede7-obsidianlivesyncdb` (Internal HA hostname)     |
| Forward Port       | `5984`                                                   |
| Websockets Support | Enabled                                                  |
| HTTP/2 Support     | Enabled                                                  |
| SSL                | Force SSL enabled with a valid Let's Encrypt certificate |

**Advanced Nginx Snippet (Custom Nginx Configuration):**

Add this to the *Advanced* tab:

```nginx
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

## ⚠️ Updates & Plugin Requirements

The initialization script applies specific CouchDB tuning required by the **Self-hosted LiveSync** plugin.

If the Obsidian plugin is updated and its CouchDB requirements change, the app's initialization logic might need an update. In such cases, after the app is updated in Home Assistant, it is recommended to rebuild the image to ensure all configurations are correctly reapplied.

## 💾 Data & Backups

The application persists data across two different locations:

- **Database Content**: Stored in `/opt/couchdb/data` (mapped to HA `data` partition).
- **Configuration**: Stored in `/opt/couchdb/etc/local.d` (mapped to HA `addon_config` partition).

**Both locations are automatically included** when Home Assistant performs a backup of this application.

## First Time Setup

1. Once the app is running, open Obsidian
1. Go to **Settings > Community Plugins > Self-hosted LiveSync**
1. Run the **Setup Wizard** provided by the plugin