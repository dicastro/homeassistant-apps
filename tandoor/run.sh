#!/bin/sh
# shellcheck shell=sh
# ==============================================================================
# My Home Assistant App: Tandoor Recipes
# Runs the Tandoor Recipes application
# ==============================================================================

OPTIONS_FILE="/opt/recipes/options.json"
SECRET_FILE="/opt/recipes/tandoor_secret.txt"

# Helper to extract a top-level string value from OPTIONS_FILE JSON
# Usage: get_opt "key"
# Returns the value associated with the given key.
get_opt() {
    grep -o "\"$1\": *\"[^\"]*\"" "$OPTIONS_FILE" | cut -d'"' -f4
}

# Fixed Tandoor Recipes Env Vars
export DB_ENGINE="django.db.backends.sqlite3"

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
if [ -s "$SECRET_FILE" ]; then
    SECRET_KEY=$(cat "$SECRET_FILE")
else
    SECRET_KEY=$(head -c 128 /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 64)
    printf "%s" "$SECRET_KEY" > "$SECRET_FILE"
fi

export SECRET_KEY

# Allowed hosts
ALLOWED_HOSTS_VAL=$(
sed -n '/"allowed_hosts"/,/\]/p' "$OPTIONS_FILE" |
grep -o '"[^"]*"' |
tr -d '"' |
paste -sd "," -
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