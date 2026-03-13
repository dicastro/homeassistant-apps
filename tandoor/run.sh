#!/bin/sh
# shellcheck shell=sh
# ==============================================================================
# My Home Assistant App: Tandoor Recipes
# Runs the Tandoor Recipes application
# ==============================================================================

DATA_DIR="/data"
OPTIONS_FILE="$DATA_DIR/options.json"
SECRET_KEY_FILE="$DATA_DIR/tandoor_secret_key.txt"

MEDIA_ROOT="$DATA_DIR/mediafiles"
STATIC_ROOT="$DATA_DIR/staticfiles"

mkdir -p "$MEDIA_ROOT" "$STATIC_ROOT"

export MEDIA_ROOT STATIC_ROOT

# Helper to extract a top-level string value from OPTIONS_FILE JSON
# Usage: get_opt "key"
# Returns the value associated with the given key.
get_opt() {
    grep -o "\"$1\": *\"[^\"]*\"" "$OPTIONS_FILE" | cut -d'"' -f4
}

# Fixed Tandoor Recipes Env Vars
export DB_ENGINE="django.db.backends.sqlite3"
export DATABASE_URL="sqlite://fake-host-just-to-match-regex-in-settings.py/$DATA_DIR/db.sqlite3"
export TANDOOR_PORT=8080

# Timezone
TZ_VAL=$(get_opt "timezone")
[ -n "$TZ_VAL" ] && export TZ="$TZ_VAL"

# Enable Signup
ENABLE_SIGNUP_VAL=$(get_opt "enable_signup")

case "$ENABLE_SIGNUP_VAL" in
  true|True|TRUE)  export ENABLE_SIGNUP=1 ;;
  false|False|FALSE) export ENABLE_SIGNUP=0 ;;
esac

# Secret key
if [ ! -s "$SECRET_KEY_FILE" ]; then
    tr -dc 'A-Za-z0-9' </dev/urandom | head -c 64 > "$SECRET_KEY_FILE"
fi

export SECRET_KEY_FILE

# Allowed hosts
ALLOWED_HOSTS_VAL=$(
sed -n '/"allowed_hosts"/,/]/p' "$OPTIONS_FILE" |  # grab lines from key to closing ]
tr -d '\n' |                                       # join into a single line
sed -E 's/.*\[\s*(.*)\s*\].*/\1/' |                # extract contents inside [ ... ]
tr -d ' ' |                                        # remove spaces
tr -d '"' |                                        # remove quotes
tr ',' '\n' |                                      # split by commas
grep -v '^$' |                                     # remove empty entries
paste -sd "," -                                    # join as comma-separated
)

[ -n "$ALLOWED_HOSTS_VAL" ] && export ALLOWED_HOSTS="$ALLOWED_HOSTS_VAL"

# Email
EMAIL_BLOCK=$(sed -n '/"email"/,/\}/p' "$OPTIONS_FILE")

EMAIL_HOST=$(printf "%s\n" "$EMAIL_BLOCK" | grep '"host"' | cut -d'"' -f4)
EMAIL_PORT=$(printf "%s\n" "$EMAIL_BLOCK" | grep '"port"' | awk -F: '{gsub(/[, ]/,"",$2);print $2}')
EMAIL_HOST_USER=$(printf "%s\n" "$EMAIL_BLOCK" | grep '"user"' | cut -d'"' -f4)
EMAIL_HOST_PASSWORD=$(printf "%s\n" "$EMAIL_BLOCK" | grep '"password"' | cut -d'"' -f4)
EMAIL_USE_TLS=$(printf "%s\n" "$EMAIL_BLOCK" | grep '"use_tls"' | awk -F: '{gsub(/[, ]/,"",$2);print $2}')
DEFAULT_FROM_EMAIL=$(printf "%s\n" "$EMAIL_BLOCK" | grep '"default_from_email"' | cut -d'"' -f4)

[ -n "$EMAIL_HOST" ] && export EMAIL_HOST
[ -n "$EMAIL_PORT" ] && export EMAIL_PORT
[ -n "$EMAIL_HOST_USER" ] && export EMAIL_HOST_USER
[ -n "$EMAIL_HOST_PASSWORD" ] && export EMAIL_HOST_PASSWORD
[ -n "$DEFAULT_FROM_EMAIL" ] && export DEFAULT_FROM_EMAIL

case "$EMAIL_USE_TLS" in
  true|True|TRUE) export EMAIL_USE_TLS=1 ;;
  false|False|FALSE) export EMAIL_USE_TLS=0 ;;
esac

ENTRYPOINT=$(cat /original-entrypoint 2>/dev/null)
CMD=$(cat /original-cmd 2>/dev/null)

exec ${ENTRYPOINT} ${CMD}