#!/bin/sh
# shellcheck shell=bash
# ==============================================================================
# My Home Assistant App: Mailpit
# Runs the Mailpit application
# ==============================================================================

export MP_DATABASE="/data/mailpit.db"
export MP_UI_BIND_ADDR=0.0.0.0:8025
export MP_SMTP_AUTH_ALLOW_INSECURE=1
export TZ=$(bashio::config 'timezone')

build_auth_list() {
    local CONFIG_KEY=$1
    local RESULT=""

    local COUNT
    COUNT=$(bashio::config "${CONFIG_KEY} | length")

    for ((i=0;i<COUNT;i++)); do
        USER=$(bashio::config "${CONFIG_KEY}[${i}].user")
        PASS=$(bashio::config "${CONFIG_KEY}[${i}].pass")

        if [[ -n "$USER" && -n "$PASS" ]]; then
            RESULT="${RESULT}${USER}:${PASS} "
        fi
    done

    echo "${RESULT}" | xargs
}

UI_AUTH=$(build_auth_list "ui_auth")
SMTP_AUTH=$(build_auth_list "smtp_auth")
POP3_AUTH=$(build_auth_list "pop3_auth")

if [[ -n "$UI_AUTH" ]]; then
    export MP_UI_AUTH="$UI_AUTH"
    bashio::log.info "UI authentication enabled"
fi

if [[ -n "$SMTP_AUTH" ]]; then
    export MP_SMTP_AUTH="$SMTP_AUTH"
    bashio::log.info "SMTP authentication enabled"
fi

if [[ -n "$POP3_AUTH" ]]; then
    export MP_POP3_AUTH="$POP3_AUTH"
    bashio::log.info "POP3 authentication enabled"
fi

ENTRYPOINT=$(cat /original-entrypoint)
CMD=$(cat /original-cmd)

exec ${ENTRYPOINT} ${CMD}