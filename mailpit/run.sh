#!/bin/sh
# shellcheck shell=bash
# ==============================================================================
# My Home Assistant App: Mailpit
# Runs the Mailpit application
# ==============================================================================

OPTIONS_FILE="/data/options.json"

# Helper to extract a top-level string value from JSON
# Usage: get_opt "key"
get_opt() {
    grep -o "\"$1\": *\"[^\"]*\"" "$OPTIONS_FILE" | cut -d'"' -f4
}

# Helper to parse the auth arrays (user/pass objects)
# This uses sed to flatten the JSON into "user:pass" lines
parse_auth() {
    local KEY="$1"
    # 1. Find the lines between the key and the end of its array
    # 2. Extract user/pass pairs and format as user:pass
    sed -n "/\"$KEY\"/,/\]/p" "$OPTIONS_FILE" | \
    sed -n 's/.*"user": *"\([^"]*\)".*"pass": *"\([^"]*\)".*/\1:\2/p' | \
    tr '\n' ' '
}


# Standard Mailpit Env Vars
export MP_DATABASE="/data/mailpit.db"
export MP_UI_BIND_ADDR="0.0.0.0:8025"
export MP_SMTP_AUTH_ALLOW_INSECURE=1

# Timezone (using the helper)
TZ_VAL=$(get_opt "timezone")
[ -n "$TZ_VAL" ] && export TZ="$TZ_VAL"

# Auth Lists
UI_AUTH=$(parse_auth "ui_auth")
SMTP_AUTH=$(parse_auth "smtp_auth")
POP3_AUTH=$(parse_auth "pop3_auth")

[ -n "$UI_AUTH" ]   && export MP_UI_AUTH="$UI_AUTH"
[ -n "$SMTP_AUTH" ] && export MP_SMTP_AUTH="$SMTP_AUTH"
[ -n "$POP3_AUTH" ] && export MP_POP3_AUTH="$POP3_AUTH"

ENTRYPOINT=$(cat /original-entrypoint 2>/dev/null)
CMD=$(cat /original-cmd 2>/dev/null)

exec ${ENTRYPOINT} ${CMD}