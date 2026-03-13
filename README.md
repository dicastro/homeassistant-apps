# My Home Assistant Apps

# Installation

## Apps repository

First to install use the following link to add the repository:

[![Open your Home Assistant instance and show the add app repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fdicastro%2Fhomeassistant-apps)

> In order to work this link above you have to configure [my.home-assistant.io](https://my.home-assistant.io) to point to your home assistant instance (read the [FAQ](https://my.home-assistant.io/faq) for more information).

Alternatively go to the *Application Store*, Click the *three dots*, then *Repositories*, and then add the following:

```
https://github.com/dicastro/homeassistant-apps
```

# Notes

## How to get the hash of a GitHub repo needed to create links to install the app

It is hashing using SHA1

An [online tool](https://emn178.github.io/online-tools/sha1.html) can be used to hash the URL of a repo

For example this repo `https://github.com/dicastro/homeassistant-apps` has the hash `1da1ede79372013ce13f7daec6a59afa74b101d9`

The 8 first digits have to be used to reference that repo: `1da1ede7`

## How to develop an App

https://developers.home-assistant.io/docs/apps

## Official Community Apps

https://github.com/hassio-addons/repository