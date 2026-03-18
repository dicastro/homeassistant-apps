# Documentation: Mailpit

## ⚙️ Configuration

**Note**: _Remember to restart the app when the configuration is changed._

Example app configuration:

```yaml
timezone: "Europe/Madrid"
ui_auth:
   - user: "admin"
     pass: "changeme"
smtp_auth:
   - user: "app1"
     pass: "changeme"
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `timezone`

The timezone assigned to the application (e.g., Europe/Madrid, Etc/UTC).

You can get a list of timezones [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

### Option: `ui_auth`

A list of users with attributes `user` and `pass` to secure the Web UI. If left empty, no authentication is required.

### Option: `pop3_auth`

A list of users with attributes `user` and `pass` to secure the SMTP server. If left empty, no authentication is required.

### Option: `pop3_auth`

A list of users with attributes `user` and `pass` to secure the POP3 server. If left empty, no authentication is required.

## 🌐 Recommended Proxy Configuration

| Configuration      | Value                                          |
|:-------------------|:-----------------------------------------------|
| Domain Name        | `mailpit.<YOUR_DOMAIN>`                        |
| Scheme             | `http`                                         |
| Forward Hostname   | `1da1ede7-mailpit` (Internal HA hostname)      |
| Forward Port       | `8025`                                         |
| Websockets Support | Enabled                                        |
| SSL                | Enabled with a valid Let's Encrypt certificate |

## Integrating with other Apps

### Internal Applications

To send emails from other apps installed within your Home Assistant instance (e.g., **Vaultwarden** or **Tandoor Recipes**):

| Setting        | Value                                                                            |
|:---------------|:---------------------------------------------------------------------------------|
| SMTP Host      | `1da1ede7-mailpit`                                                               |
| SMTP Port      | `1025`                                                                           |
| Encryption     | None / Plain                                                                     |
| Authentication | Depends on your `smtp_auth` or `pop3_auth` config (use configured `user`/`pass`) |

### External Applications (Local Network)

To send emails from other services running in your local network but outside Home Assistant:

| Setting        | Value                                                                            |
|:---------------|:---------------------------------------------------------------------------------|
| SMTP Host      | `mailpit.<YOUR_DOMAIN>` (requires local DNS) or `<HOMEASSISTANT_IP>`             |
| SMTP Port      | `1025` (Must be exposed in the app's network settings)                           |
| Encryption     | None / Plain                                                                     |
| Authentication | Depends on your `smtp_auth` or `pop3_auth` config (use configured `user`/`pass`) |

**Note:** Since SMTP traffic uses port `1025`, it bypasses the Reverse Proxy (which only handles ports 80/443). Ensure that port `1025` is correctly exposed in the application's configuration within Home Assistant so it can receive requests from your local network.

## 💾 Data & Backups

The application persists data across the locations:

- `/data` (mapped to HA `data` partition): this includes the database where all captured emails are stored

These locations automatically managed by Home Assistant, meaning all your information **is automatically included** in your Home Assistant backups/snapshots.

## 📝 Technical Notes

### Wrapper Configurations

The application uses a custom wrapper script to set specific environment variables that ensure stability and correct persistence within the Home Assistant environment:

- **Port & UI**: `MP_UI_BIND_ADDR="0.0.0.0:8025"` explicitly sets the web interface port
- **Database Path**: `MP_DATABASE="/data/mailpit.db"` ensures the SQLite database is stored in the persistent `/data` partition
- **Insecure SMPT Auth**: `MP_SMTP_AUTH_ALLOW_INSECURE=1` is enabled to allow applications to use SMTP authentication over unencrypted (Plain/None) internal connections, which is standard for internal Docker communication

**Why this matters:** These settings ensure that your captured emails are never lost during an application update (by forcing the database location) and that other Home Assistant apps (like Vaultwarden or Tandoor) can communicate with Mailpit using simple internal credentials without the complexity of setting up local SSL certificates.

## 🔗 Useful Links

- [Mailpit configuration documentation](https://mailpit.axllent.org/docs/configuration)