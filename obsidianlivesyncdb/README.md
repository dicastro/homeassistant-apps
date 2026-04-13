# My Home Assistant App: Obsidian LiveSync DB

![Release][release-shield] ![Project Stage][project-stage-shield] ![Project Maintenance][maintenance-shield]

A specifically tuned CouchDB instance designed to work out-of-the-box with the [Obsidian Self-hosted LiveSync](https://github.com/vrtmrz/obsidian-livesync) plugin.

## ⚠️ Access & WebUI Disclaimer

Accessing this application through the Home Assistant Ingress (WebUI) is **not recommended** and has not been thoroughly tested. In some cases, internal routing within Home Assistant may cause connectivity issues.

It is **highly recommended** to use a Reverse Proxy for stable access. Personally, I use the **NGINX Proxy Manager** add-on for Home Assistant, but any other proxy solution is valid as long as a configuration equivalent to the one suggested in the documentation is applied.

## Features

- **Optimized for Obsidian:** Pre-configured settings for the LiveSync plugin
- **Persistent Storage:** Keep your notes database safe within your Home Assistant backups
- **Easy Access:** Simple credential management via the Home Assistant UI

## Quick Start

1. Install the application
1. Set the required values in the **Configuration** tab (refer to the *Configuration* section in the documentation)
1. Start the application
1. Check the application logs to ensure the initialization process finished successfully
1. Configure your Reverse Proxy (refer to the *Recomended Proxy Configuration* section in the documentation)
1. Link your Obsidian vault following the steps in the documentation

[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production-brightgreen.svg
[release-shield]: https://img.shields.io/badge/version-3.4.3-blue.svg