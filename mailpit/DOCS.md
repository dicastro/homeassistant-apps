# My Home Assistant App: Mailpit

## Installation

The installation of this app is pretty straightforward and not different in
comparison to installing any other Home Assistant app.

1. Click the Home Assistant My button below to open the app on your Home Assistant instance
   [![Open this app in your Home Assistant instance.][addon-badge]][addon]
2. Click the "Install" button to install the app
3. Start the "`Mailpit`" app
4. Check the logs of the "Mailpit" app to see if everything went well
5. Click the "OPEN WEB UI" button to open Mailpit

## Configuration

**Note**: _Remember to restart the app when the configuration is changed._

Example app configuration:

```yaml
timezone: "Europe/Madrid"
smtp_auth: "smtpuser:smtppass anothersmtpuser:anothersmtpuserpass"
pop3_auth: "pop3user:pop3pass anotherpop3user:anotherpop3userpass"
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `timezone`

Establishes a timezone

You can get a list of timezones [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

https://mailpit.axllent.org/docs/configuration/

[addon-badge]: https://my.home-assistant.io/badges/supervisor_addon.svg
[addon]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=1da1ede7_mailpit&repository_url=https%3A%2F%2Fgithub.com%2Fdicastro%2Fhomeassistant-apps

## Known issues and limitations

- This app cannot support Ingress at this time due to technical limitations of the Mailpit web interface