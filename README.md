# My Home Assistant Apps

This repository contains a collection of applications for Home Assistant that are not available in the official or community repositories. I decided to create and maintain these to streamline my daily workflow and ensure I have access to the specific tools I need within my Home Assistant ecosystem.

## 🚀 Installation

### Add Application Repository

Click the badge below to add this repository to your Home Assistant instance automatically:

[![Open your Home Assistant instance and show the add app repository dialog with a specific repository URL pre-filled](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fdicastro%2Fhomeassistant-apps)

> **Note:** For the link above to work, you must configure [my.home-assistant.io](https://my.home-assistant.io) to point to your instance (read the [FAQ](https://my.home-assistant.io/faq) for more information).

**Manual Installation:**

1. Navigate to the **Application Store** in Home Assistant
2. Click the **three dots** (top right) > **Repositories**
3. Add the following URL

```
https://github.com/dicastro/homeassistant-apps
```

## ✅ Advantages

Using these applications within Home Assistant provides several benefits:

* **Automated Updates:** This repository uses a custom GitHub Actions workflow that automatically checks for new upstream versions (via GitHub Releases or Docker Hub) and updates the app metadata.
* **Seamless Upgrades:** Home Assistant notifies you immediately when a new version is available, allowing for one-click upgrades.
* **Safety First:** Home Assistant supports creating an automatic backup before performing any application upgrade, ensuring you can revert if needed.

## 📦 Included Applications

| Application                                                                                         | Install                                                                               | Description                                                                              |
|:----------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------|
| [ActualBudget](https://github.com/dicastro/homeassistant-apps/tree/main/actualbudget)               | [![Open this app in your Home Assistant instance][app-badge]][actualbudget-app]       | A local-first personal finance tool and 100% free and open-source.                       |
| [Heimdall](https://github.com/dicastro/homeassistant-apps/tree/main/heimdall)                       | [![Open this app in your Home Assistant instance][app-badge]][heimdall-app]           | An elegant dashboard to centralize links to all your web applications.                   |
| [Mailpit](https://github.com/dicastro/homeassistant-apps/tree/main/mailpit)                         | [![Open this app in your Home Assistant instance][app-badge]][mailpit-app]            | Email testing tool for developers (SMTP server with web UI).                             |
| [Obsidian LiveSync DB](https://github.com/dicastro/homeassistant-apps/tree/main/obsidianlivesyncdb) | [![Open this app in your Home Assistant instance][app-badge]][obsidianlivesyncdb-app] | A specifically configured CouchDB instance for the Obsidian Self-hosted LiveSync plugin. |
| [Tandoor Recipes](https://github.com/dicastro/homeassistant-apps/tree/main/tandoor)                 | [![Open this app in your Home Assistant instance][app-badge]][tandoor-app]            | A comprehensive recipe manager to manage your cooking recipes and meal planning. |

## 🌐 External Access & Security

Access to these applications is designed to be managed through **NGINX Proxy Manager** (available in the official Home Assistant Community Apps).

Each application folder contains a `DOC.md` file with a **"Recommended Proxy Configuration"** section, detailing how to set up proxy hosts, SSL, and security headers for that specific app.

## ❓ FAQ & Development Notes

### How to add a new Application

If you want to contribute or add a new app to your local fork:

1. Refer to the [Official Home Assistant Developer Documentation](https://developers.home-assistant.io/docs/add-ons).
2. **Auto-Update System:** I have implemented a custom `upgrade.yaml` file in each app folder. This allows the GitHub workflow to sync versions automatically.

**Sample `upgrade.yaml` (GitHub Source):**

```yaml
upgrade_config:
  source: "github_releases"
  repo: "tandoorrecipes/recipes"
  version: "2.5.3"
```

> Note: If a GitHub `tag_name` (e.g., `v26.3.0`) does not match the Docker Registry tag (e.g., `26.3.0`), use `docker_hub` as the source instead.

**Sample `upgrade.yaml` (Docker Hub Source):**

```yaml
upgrade_config:
  source: "docker_hub"
  image: "library/couchdb"
  version: "3.5.1"
  # This regex ensures we only get stable versions like 3.5.1
  tag_regex: "^[0-9]+\\.[0-9]+\\.[0-9]+$"
```

### Repository Hashing (for Installation Links)

Home Assistant uses a SHA1 hash of the repository URL to generate unique identifiers.

- Example URL: `https://github.com/dicastro/homeassistant-apps`
- Full SHA1 Hash: `1da1ede79372013ce13f7daec6a59afa74b101d9`
- App ID Prefix: Use the first 8 characters (`1da1ede7`) to reference this repository in deep links.

You can use an [online tool](https://emn178.github.io/online-tools/sha1.html) to calculate hashes for other repositories.

### How to see environment variables of a process

```
> cat /proc/<PID>/environ | tr '\0' '\n'

# e.g. Main process of a container has PID=1

> cat /proc/1/environ | tr '\0' '\n'
```

## 🔗 Useful Links

- [Official Home Assistant Apps Documentation](https://developers.home-assistant.io/docs/add-ons)
- [Official Home Assistant Community Apps Repo](https://github.com/hassio-addons/repository)


[app-badge]: https://my.home-assistant.io/badges/supervisor_addon.svg
[actualbudget-app]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=1da1ede7_actualbudget&repository_url=https%3A%2F%2Fgithub.com%2Fdicastro%2Fhomeassistant-apps
[heimdall-app]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=1da1ede7_heimdall&repository_url=https%3A%2F%2Fgithub.com%2Fdicastro%2Fhomeassistant-apps
[mailpit-app]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=1da1ede7_mailpit&repository_url=https%3A%2F%2Fgithub.com%2Fdicastro%2Fhomeassistant-apps
[obsidianlivesyncdb-app]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=1da1ede7_obsidianlivesyncdb&repository_url=https%3A%2F%2Fgithub.com%2Fdicastro%2Fhomeassistant-apps
[tandoor-app]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=1da1ede7_tandoor&repository_url=https%3A%2F%2Fgithub.com%2Fdicastro%2Fhomeassistant-apps