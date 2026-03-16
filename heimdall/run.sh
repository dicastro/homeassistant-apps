#!/bin/sh
# shellcheck shell=sh
# ==============================================================================
# My Home Assistant App: Heimdall
# Runs the Heimdall application
# ==============================================================================

DATA_DIR="/config"
OPTIONS_FILE="$DATA_DIR/options.json"

# Helper to extract a top-level string value from OPTIONS_FILE JSON
# Usage: get_opt "key"
# Returns the value associated with the given key.
get_opt() {
    grep -o "\"$1\": *\"[^\"]*\"" "$OPTIONS_FILE" | cut -d'"' -f4
}

# Timezone
TZ_VAL=$(get_opt "timezone")
[ -n "$TZ_VAL" ] && export TZ="$TZ_VAL"

ENTRYPOINT=$(cat /original-entrypoint 2>/dev/null)
CMD=$(cat /original-cmd 2>/dev/null)

exec ${ENTRYPOINT} ${CMD}