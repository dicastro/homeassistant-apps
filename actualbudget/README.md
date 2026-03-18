# My Home Assistant App: ActualBudget

![Release][release-shield] ![Project Stage][project-stage-shield] ![Project Maintenance][maintenance-shield]

[ActualBudget](https://actualbudget.org) is a local-first personal finance tool that is 100% free and open-source. Manage your finances with privacy and efficiency directly from your Home Assistant instance.

## ⚠️ Access & WebUI Disclaimer

Accessing this application through the Home Assistant Ingress (WebUI) is **not recommended** and has not been thoroughly tested. In some cases, internal routing within Home Assistant may cause connectivity issues.

It is **highly recommended** to use a Reverse Proxy for stable access. Personally, I use the **NGINX Proxy Manager** add-on for Home Assistant, but any other proxy solution is valid as long as a configuration equivalent to the one suggested in the documentation is applied.

## Features

* **Privacy First:** Your financial data stays local and under your control
* **Budgeting Simplified:** High-performance envelope budgeting system
* **Multi-device Sync:** Seamlessly sync your budget between your devices
* **Reporting:** Built-in tools to visualize your spending and net worth trends

## Quick Start

1. Install the application
1. Start the application
1. Check the application logs to ensure the initialization process finished successfully
1. Configure your Reverse Proxy (refer to the *Recomended Proxy Configuration* section in the documentation)
1. Access the web interface via your proxy URL to set up your admin password and create your first budget

[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production-brightgreen.svg
[release-shield]: https://img.shields.io/badge/version-26.3.0-blue.svg