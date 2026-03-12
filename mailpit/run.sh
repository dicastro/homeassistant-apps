#!/bin/sh
# shellcheck shell=sh
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
    KEY="$1"
    # 1. Isolate the block (e.g., ui_auth)
    # 2. Extract values into u/p buffers, then print when the object } ends
    sed -n "/\"$KEY\"/,/\]/p" "$OPTIONS_FILE" | awk '
        /"user":/ { split($0, a, "\""); u=a[4] }
        /"pass":/ { split($0, a, "\""); p=a[4] }
        /\}/ {
            if (u != "" && p != "") printf "%s:%s ", u, p;
            u=""; p=""
        }
    ' | sed 's/ $//' | tr -d '\r\n'
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
if [ -z "$UI_AUTH" ]; then
    echo "No UI authentication configured"
else
    export MP_UI_AUTH="$UI_AUTH"
    echo "UI authentication enabled for users"
fi

SMTP_AUTH=$(parse_auth "smtp_auth")
if [ -z "$SMTP_AUTH" ]; then
    echo "No SMTP authentication configured"
else
    export MP_SMTP_AUTH="$SMTP_AUTH"
    echo "SMTP authentication enabled for users"
fi

POP3_AUTH=$(parse_auth "pop3_auth")
if [ -z "$POP3_AUTH" ]; then
    echo "No POP3 authentication configured"
else
    export MP_POP3_AUTH="$POP3_AUTH"
    echo "POP3 authentication enabled for users"
fi

ENTRYPOINT=$(cat /original-entrypoint 2>/dev/null)
CMD=$(cat /original-cmd 2>/dev/null)

exec ${ENTRYPOINT} ${CMD}