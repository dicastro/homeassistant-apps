ARG BUILD_FROM

FROM ${BUILD_FROM}

USER root

# Install curl (required depencency by the livesync configuration script)
RUN apt-get update && \
    apt-get install -y curl jq && \
    rm -rf /var/lib/apt/lists/*

ARG ORIGINAL_ENTRYPOINT
ARG ORIGINAL_CMD

RUN echo "${ORIGINAL_ENTRYPOINT}" > /original-entrypoint && \
    echo "${ORIGINAL_CMD}" > /original-cmd

# Descargamos el script oficial de configuración
ENV OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT /usr/local/bin/obsidian-livesync-couchdb-init.sh
ADD https://raw.githubusercontent.com/vrtmrz/obsidian-livesync/main/utils/couchdb/couchdb-init.sh $OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT
RUN chmod +x $OBSIDIAN_LIVESYNC_COUCHDB_INIT_SCRIPT

COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]