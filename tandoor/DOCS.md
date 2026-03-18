# Documentation: Tandoor Recipes

Tandoor Recipes is a Django-based application. This version is pre-configured to use **SQLite** for simplicity and full integration with Home Assistant backups.

## ⚙️ Configuration

**Note**: _Remember to restart the app when the configuration is changed._

Example app configuration:

```yaml
timezone: "Europe/Madrid"
enable_signup: true
allowed_hosts:
  - "recipes.<YOUR_DOMAIN>"
email:
  host: "1da1ede7-mailpit"
  port: 1025
  user: "tandoor"
  password: "changeme"
  use_tls: "false"
  default_from_email: "no-reply@recipes.<YOUR_DOMAIN>"
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `timezone`

The timezone assigned to the application (e.g., Europe/Madrid, Etc/UTC).

You can get a list of timezones [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

### Option: `enable_signup`

Set to `true` to allow new users to register.

### Option: `allowed_hosts`

A list of hostnames/domains that this Tandoor instance can serve.

### Option: `email`

Configuration block for SMTP (Host, Port, User, Password, TLS).

#### Sub-option: `host`
#### Sub-option: `port`
#### Sub-option: `user`
#### Sub-option: `password`
#### Sub-option: `use_tls`
#### Sub-option: `default_from_email`

## 🌐 Recommended Proxy Configuration

| Configuration      | Value                                                    |
|:-------------------|:---------------------------------------------------------|
| Domain Name        | `recipes.<YOUR_DOMAIN>`                                  |
| Scheme             | `http`                                                   |
| Forward Hostname   | `1da1ede7-tandoor` (Internal HA hostname)                |
| Forward Port       | `8080`                                                   |
| Websockets Support | Enabled                                                  |
| SSL                | Force SSL enabled with a valid Let's Encrypt certificate |

**Advanced Nginx Snippet:**

```nginx
  # Increase maximum upload size for recipes with large attachments
  client_max_body_size 50M;
  
  # Optimization for long-lived connections
  proxy_read_timeout 300s;
  proxy_connect_timeout 300s;
  proxy_send_timeout 300s;
```

## 🚀 Initial Setup (First Run)

Tandoor uses a "Space" and "Invite" system. Follow these steps carefully to set up your first user:

1. Access the web interface via your Proxy URL
1. Create a **superuser** account (this is the administrator)
1. Log in as the superuser and create a new **Recipe Space**
1. Navigate to **Settings > Space Members > Invites > + NEW** and create an invitation for yourself
1. Copy the invite link, then **Logout** as superuser
1. Access the invite link (Note: remove the final `/` if the link doesn't load)
1. Fill in the signup form to create your **daily-use account**

## 💾 Data & Backups

The application persists data across the locations:

- `/data` (mapped to HA `data` partition): this includes the database where all recipes are stored, media files, static files and the encription key

These locations automatically managed by Home Assistant, meaning all your information **is automatically included** in your Home Assistant backups/snapshots.

## 📝 Technical Notes

### Wrapper Configurations

The application uses a custom wrapper script set specific environment variables that ensure stability and correct persistence within the Home Assistant environment:

- **Database Engine**: `DB_ENGINE="django.db.backends.sqlite3"` explicitly forces the application to use the SQLite engine instead of requiring an external database like PostgreSQL
- **Database Location**: `DATABASE_URL="sqlite://fake-host-just-to-match-regex-in-settings.py/data/db.sqlite3"` overrides the default internal path to ensure the database file is stored in the persistent `/data` partition, making it accessible for backups
  - Note on "fake-host": The Tandoor URL parser expects a `protocol://host/path` structure. Sinche the "host" is irrelevant for SQLite, this placeholder is used to satisfy the internal regex validation without affecting the actual database connection
- **Secret Key**: `SECRET_KEY_FILE="/data/tandoor_secret_key.txt"` points to a persistent file where a unique 64-character key is generated on the first boot
- **Port Binding**: `TANDOOR_PORT=8080` ensures the internal server consistently listens on the port expected by the Home Assistant network configuration

**Why this matters**: These configurations ensure that your cookbook data and images survive application updates. By forcing the SQLite path and generating a persistent Secret Key, we ensure that your sessions and encrypted data remain valid even after restarting or rebuilding the app.

## 🔗 Useful Links

- [Tandoor Recipes Configuration Documentation](https://docs.tandoor.dev/system/configuration)