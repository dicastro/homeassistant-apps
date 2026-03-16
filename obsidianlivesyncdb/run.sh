#!/bin/bash
# shellcheck shell=bash
# ==============================================================================
# My Home Assistant App: Obsidian LiveSync DB
# Runs and initializes an instance of CouchDB required by Obsidian LiveSync plugin
# ==============================================================================

DATA_DIR="/opt/couchdb/data"
OPTIONS_FILE="$DATA_DIR/options.json"
OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT_HASH_FILE="$DATA_DIR/obsidian-livesync-couchdb-init.script_hash"

# User & Password
USER_VAL=$(jq --raw-output '.user' "$OPTIONS_FILE")
PASSWORD_VAL=$(jq --raw-output '.password' "$OPTIONS_FILE")

# Required variables for CouchDB
export COUCHDB_USER="$USER_VAL"
export COUCHDB_PASSWORD="$PASSWORD_VAL"

ENTRYPOINT=$(cat /original-entrypoint 2>/dev/null)
CMD=$(cat /original-cmd 2>/dev/null)

OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT_CURRENT_HASH=$(sha256sum "$OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT" | awk '{ print $1 }')

OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT_PREVIOUS_HASH=""
[ -f "$OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT_HASH_FILE" ] && OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT_PREVIOUS_HASH=$(cat "$OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT_HASH_FILE")

if [ "$OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT_CURRENT_HASH" != "$OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT_PREVIOUS_HASH" ]; then
  echo "[Wrapper] New version or first execution detected. Configuring couchdb..."

  # Start CouchDB temporarily
  ${ENTRYPOINT} ${CMD} &
  COUCHDB_PID=$!

  # Wait for CouchDB to start
  echo "[Wrapper] Waiting for CouchDB to respond..."
  MAX_RETRIES=30
  RETRIED=0
  while ! curl -s http://127.0.0.1:5984/_up >/dev/null 2>&1; do
    sleep 2
    RETRIED=$((RETRIED+1))
    if [ $RETRIED -ge $MAX_RETRIES ]; then
      echo "[Wrapper] ERROR: CouchDB did not start after $MAX_RETRIES retries"
      kill $COUCHDB_PID 2>/dev/null
      exit 1
    fi
  done

  echo "[Wrapper] Executing Obsidian LiveSync init script..."

  # Define local function to silence all curl invocations in the external script
  curl() {
    command curl -s "$@"
  }
  export -f curl # Export the function to be viewed by the 'bash script.sh' subshell

  hostname="http://127.0.0.1:5984" \
  username="$USER_VAL" \
  password="$PASSWORD_VAL" \
  node="_local" \
  bash "$OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT"

  # Removed the exposed function to do not affect subsequent invocations
  unset -f curl

  # Persist hash for the next execution
  echo "$OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT_CURRENT_HASH" > "$OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT_HASH_FILE"

  # Clean stop before final exec
  kill $COUCHDB_PID
  wait $COUCHDB_PID

  echo "[Wrapper] Obsidian LiveSync configuration applied successfully"
fi

echo "[Wrapper] Starting CouchDB in operational mode..."
exec ${ENTRYPOINT} ${CMD}