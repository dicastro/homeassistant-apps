# My Home Assistant App: Heimdall

![Release][release-shield] ![Project Stage][project-stage-shield] ![Project Maintenance][maintenance-shield]

[Heimdall](https://heimdall.site) is an elegant dashboard to centralize links to all your web applications. Heimdall allows you to organize your home network services in a clean, visual, and customizable interface.

## ⚠️ Access & WebUI Disclaimer

Accessing this application through the Home Assistant Ingress (WebUI) is **not recommended** and has not been thoroughly tested. In some cases, internal routing within Home Assistant may cause connectivity issues.

It is **highly recommended** to use a Reverse Proxy for stable access. Personally, I use the **NGINX Proxy Manager** add-on for Home Assistant, but any other proxy solution is valid as long as a configuration equivalent to the one suggested in the documentation is applied.

## Features

- **App Integration:** Support for many foundations with enhanced "Enhanced Apps" that show live data (e.g., Pi-hole stats, Transmission speeds)
- **Fully Customizable:** Change backgrounds, colors, and icons easily
- **Search Bar:** Built-in search functionality using your favorite search engine
- **User Management:** Support for multiple users with different dashboard layouts

## Quick Start

1. Install the application
1. Set the required values in the **Configuration** tab (refer to the *Configuration* section in the documentation)
1. Start the application
1. Check the application logs to ensure the initialization process finished successfully
1. Configure your Reverse Proxy (refer to the *Recomended Proxy Configuration* section in the documentation)
1. Access the web interface via your proxy URL and start adding your favorite apps and services

[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production-brightgreen.svg
[release-shield]: https://img.shields.io/badge/version-2.7.6-blue.svg