# Documentation: Obsidian LiveSync DB

This application provides a CouchDB server optimized for the Obsidian Self-hosted LiveSync plugin.

## ⚙️ Configuration

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

## 🌐 Recommended Proxy Configuration

| Configuration      | Value                                                    |
|:-------------------|:---------------------------------------------------------|
| Domain Name        | `obsidianlivesyncdb.<YOUR_DOMAIN>`                       |
| Scheme             | `http`                                                   |
| Forward Hostname   | `1da1ede7-obsidianlivesyncdb` (Internal HA hostname)     |
| Forward Port       | `5984`                                                   |
| Websockets Support | Enabled                                                  |
| HTTP/2 Support     | Enabled                                                  |
| SSL                | Force SSL enabled with a valid Let's Encrypt certificate |

**Advanced Nginx Snippet**

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

## 🔗 Link your Obsidian Vault

### A. Setup the First Device

Follow these steps if this is the first time you are connecting an Obsidian vault to this database:

1. Install the **Self-hosted LiveSync** plugin in Obsidian
1. Open the plugin settings and run the Setup Wizard
1. Select **CouchDB** as your remote type
1. Provide your connection details:
    - URL: `https://obsidianlivesyncdb.<YOUR_DOMAIN>`
    - Username: the `user` set in configuration
    - Password: the `password` set in configuration
    - Database name: the database name used for synchronization (e.g. `obsidian-vault`)
1. Complete the wizard
1. **Enable Synchronization** in the plugin settings

### B. Setup Additional Devices

Once you have one device linked, adding more is much simpler:

1. On the already linked device, go to the plugin settings and select **Copy current configuration to clipboard** (this generates a setup link/string)
1. Install the plugin on the new device
1. Open the plugin settings and select **Use the setup link from another device**
1. Paste the configuration string
1. **Enable Synchronization** on the new device.

## ⚠️ Updates & Plugin Requirements

The initialization script applies specific CouchDB tuning required by the **Self-hosted LiveSync** plugin.

If the Obsidian plugin is updated and its CouchDB requirements change, the app's initialization logic might need an update. In such cases, after the app is updated in Home Assistant, it is recommended to rebuild the image to ensure all configurations are correctly reapplied.

## 💾 Data & Backups

The application persists data across the locations:

- `/opt/couchdb/data` (mapped to HA `data` partition): database content
- `/opt/couchdb/etc/local.d` (mapped to HA `addon_config` partition): configuration

These locations automatically managed by Home Assistant, meaning all your information **is automatically included** in your Home Assistant backups/snapshots.

## 🎛️ Administration Console (Fauxton)

CouchDB includes a built-in web interface called **Fauxton** for database management.

You can access it at: `http://<YOUR_HOME_ASSISTANT_IP>:5984/_utils/`

**Note:** Use the credentials defined in your configuration tab to log in