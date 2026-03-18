# My Home Assistant App: Tandoor Recipes

![Release][release-shield] ![Project Stage][project-stage-shield] ![Project Maintenance][maintenance-shield]

[Tandoor Recipes](https://tandoor.dev) is a comprehensive recipe manager to manage your cooking recipes, meal planning, and shopping lists. Tandoor Recipes is a powerful tool to organize your digital cookbook.

## ⚠️ Access & WebUI Disclaimer

Accessing this application through the Home Assistant Ingress (WebUI) is **not recommended** and has not been thoroughly tested. In some cases, internal routing within Home Assistant may cause connectivity issues.

It is **highly recommended** to use a Reverse Proxy for stable access. Personally, I use the **NGINX Proxy Manager** add-on for Home Assistant, but any other proxy solution is valid as long as a configuration equivalent to the one suggested in the documentation is applied.

## Features

- **Recipe Scraping:** Import recipes from thousands of websites automatically
- **Meal Planning:** Organize your weekly meals with a clean calendar view
- **Shopping Lists:** Generate shopping lists based on your planned recipes
- **Highly Customizable:** Add your own tags, cuisines, and ingredients

## Quick Start

1. Set the required values in the **Configuration** tab (refer to the *Configuration* section in the documentation)
1. Start the application
1. Check the application logs to ensure the initialization process finished successfully
1. Configure your Reverse Proxy (refer to the *Recomended Proxy Configuration* section in the documentation)
1. Follow the **Initial Setup** guide in the documentation to create your user and space

[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production-brightgreen.svg
[release-shield]: https://img.shields.io/badge/version-2.5.3-blue.svg