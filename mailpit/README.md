# My Home Assistant App: Mailpit

![Release][release-shield] ![Project Stage][project-stage-shield] ![Project Maintenance][maintenance-shield]

[MailPit](mailpit.axllent.org) is an email and SMTP testing tool with a modern web interface. Mailpit acts as a local SMTP server that catches any email sent to it, allowing you to inspect them without actually sending them to the internet.

## ⚠️ Access & WebUI Disclaimer

Accessing this application through the Home Assistant Ingress (WebUI) is **not recommended** and has not been thoroughly tested. In some cases, internal routing within Home Assistant may cause connectivity issues.

It is **highly recommended** to use a Reverse Proxy for stable access. Personally, I use the **NGINX Proxy Manager** add-on for Home Assistant, but any other proxy solution is valid as long as a configuration equivalent to the one suggested in the documentation is applied.

## Features

- **SMTP Server:** A lightweight SMTP server to capture emails from your other Home Assistant apps
- **Modern Web UI:** View, search, and delete captured emails in a fast, responsive interface
- **API Support:** Includes a REST API to retrieve or delete messages programmatically
- **Mobile Friendly:** The interface works perfectly on mobile devices for quick checks

## Quick Start

1. Install the application
1. Set the required values in the **Configuration** tab (refer to the *Configuration* section in the documentation)
1. Start the application
1. Check the application logs to ensure the initialization process finished successfully
1. Configure your Reverse Proxy (refer to the *Recomended Proxy Configuration* section in the documentation)
1. Use the SMTP settings provided in the documentation to configure your other services (e.g., Vaultwarden, Tandoor Recipes)
1. Access the web interface via your proxy URL

[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production-brightgreen.svg
[release-shield]: https://img.shields.io/badge/version-v1.29.6-blue.svg