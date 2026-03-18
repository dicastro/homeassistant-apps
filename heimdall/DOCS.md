# Documentation: Heimdall

Heimdall Dashboard is a way to organize all those links to your most-used web sites and applications in a simple way.

## ⚙️ Configuration

**Note**: _Remember to restart the app when the configuration is changed._

Example app configuration:

```yaml
timezone: "Europe/Madrid"
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `timezone`

The timezone assigned to the application (e.g., Europe/Madrid, Etc/UTC). This ensures scheduled tasks and logs reflect the correct time.

## 🌐 Recommended Proxy Configuration

| Configuration    | Value                                          |
|:-----------------|:-----------------------------------------------|
| Domain Name      | `home.<YOUR_DOMAIN>`                           |
| Scheme           | `http`                                         |
| Forward Hostname | `1da1ede7-heimdall` (Internal HA hostname)     |
| Forward Port     | `80`                                           |
| SSL              | Enabled with a valid Let's Encrypt certificate |

**Note:** If you use "Enhanced Apps" that point to other internal Home Assistant apps, ensure Heimdall can reach those internal URLs or use their public proxy URLs.

## 💾 Data & Backups

The application persists data across the locations:

1. `/config` (mapped to HA `data` partition): this includes the database with your links, user settings, app configurations and visual assets (custom icons and background images)

These locations automatically managed by Home Assistant, meaning all your information **is automatically included** in your Home Assistant backups/snapshots.

## 📝 Technical Notes

### Permissions (PUID/PGID)

The application is configured via a wrapper to run with `PUID: 1000` and `PGID: 1000`. On every startup, the wrapper automatically adjusts the ownership of the `/config` directory to these IDs. This ensures that even if the base image defaults change, your data remains accessible and correctly permissioned.

## ❓ FAQ

### How to change title of site?

Add the following snippet to the custom js in settings

```javascript
document.title = "<YOUR_DESIRED_TITLE>";
```