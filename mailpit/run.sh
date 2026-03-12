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

parse_auth_to_file() {
    KEY="$1"
    DEST="$2"
    # Ensure file is empty
    : > "$DEST"
    # Extract u:p from JSON and write directly to file (No shell expansion)
    sed -n "/\"$KEY\"/,/\]/p" "$OPTIONS_FILE" | awk '
        /"user":/ { split($0, a, "\""); u=a[4] }
        /"pass":/ { split($0, a, "\""); p=a[4] }
        /\}/ { if (u != "" && p != "") printf "%s:%s ", u, p; u=p="" }
    ' >> "$DEST"
}


# Standard Mailpit Env Vars
export MP_DATABASE="/data/mailpit.db"
export MP_UI_BIND_ADDR="0.0.0.0:8025"
export MP_SMTP_AUTH_ALLOW_INSECURE=1

# Timezone (using the helper)
TZ_VAL=$(get_opt "timezone")
[ -n "$TZ_VAL" ] && export TZ="$TZ_VAL"

# Auth Lists
UI_AUTH_FILE="/data/mailpit_ui_auth.txt"
parse_auth_to_file "ui_auth" "$UI_AUTH_FILE"

if [ -s "$UI_AUTH_FILE" ]; then
    export MP_UI_AUTH_FILE="$UI_AUTH_FILE"
    echo "UI authentication enabled via file"
fi

SMTP_AUTH_FILE="/data/mailpit_smtp_auth.txt"
parse_auth_to_file "smtp_auth" "$SMTP_AUTH_FILE"

if [ -s "$SMTP_AUTH_FILE" ]; then
    export MP_SMTP_AUTH_FILE="$SMTP_AUTH_FILE"
    echo "SMTP authentication enabled via file"
fi

POP3_AUTH_FILE="/data/mailpit_pop3_auth.txt"
parse_auth_to_file "pop3_auth" "$POP3_AUTH_FILE"

if [ -s "$POP3_AUTH_FILE" ]; then
    export MP_POP3_AUTH_FILE="$POP3_AUTH_FILE"
    echo "POP3 authentication enabled via file"
fi

ENTRYPOINT=$(cat /original-entrypoint 2>/dev/null)
CMD=$(cat /original-cmd 2>/dev/null)

exec ${ENTRYPOINT} ${CMD}