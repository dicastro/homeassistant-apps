#!/bin/sh
# shellcheck shell=sh
# ==============================================================================
# My Home Assistant App: Mailpit
# Runs the Mailpit application
# ==============================================================================

OPTIONS_FILE="/data/options.json"

# Helper to extract a top-level string value from OPTIONS_FILE JSON
# Usage: get_opt "key"
# Returns the value associated with the given key.
get_opt() {
    grep -o "\"$1\": *\"[^\"]*\"" "$OPTIONS_FILE" | cut -d'"' -f4
}

# Helper to extract user:pass authentication pairs from a JSON array
# Usage: parse_auth_to_file "auth_key" "destination_file"
# Reads entries under the given auth_key in OPTIONS_FILE and writes each
# "user:pass" pair on a separate line in the destination file.
parse_auth_to_file() {
    KEY="$1"
    DEST="$2"
    # Ensure file is empty
    : > "$DEST"
    # Extract u:p from JSON and write directly to file (No shell expansion)
    sed -n "/\"$KEY\"/,/\]/p" "$OPTIONS_FILE" | awk '
        /"user":/ { split($0, a, "\""); u=a[4] }
        /"pass":/ { split($0, a, "\""); p=a[4] }
        /\}/ { if (u != "" && p != "") printf "%s:%s\n", u, p; u=p="" }
    ' >> "$DEST"
}


# Fixed Mailpit Env Vars
export MP_DATABASE="/data/mailpit.db"
export MP_UI_BIND_ADDR="0.0.0.0:8025"
export MP_SMTP_AUTH_ALLOW_INSECURE=1

# Timezone
TZ_VAL=$(get_opt "timezone")
[ -n "$TZ_VAL" ] && export TZ="$TZ_VAL"

# UI - Authentication
UI_AUTH_FILE="/data/mailpit_ui_auth.txt"
parse_auth_to_file "ui_auth" "$UI_AUTH_FILE"

if [ -s "$UI_AUTH_FILE" ]; then
    export MP_UI_AUTH_FILE="$UI_AUTH_FILE"
    echo "[Wrapper] UI authentication enabled via file"
fi

# SMTP - Authentication
SMTP_AUTH_FILE="/data/mailpit_smtp_auth.txt"
parse_auth_to_file "smtp_auth" "$SMTP_AUTH_FILE"

if [ -s "$SMTP_AUTH_FILE" ]; then
    export MP_SMTP_AUTH_FILE="$SMTP_AUTH_FILE"
    echo "[Wrapper] SMTP authentication enabled via file"
fi

# POP3 - Authentication
POP3_AUTH_FILE="/data/mailpit_pop3_auth.txt"
parse_auth_to_file "pop3_auth" "$POP3_AUTH_FILE"

if [ -s "$POP3_AUTH_FILE" ]; then
    export MP_POP3_AUTH_FILE="$POP3_AUTH_FILE"
    echo "[Wrapper] POP3 authentication enabled via file"
fi

ENTRYPOINT=$(cat /original-entrypoint 2>/dev/null)
CMD=$(cat /original-cmd 2>/dev/null)

exec ${ENTRYPOINT} ${CMD}