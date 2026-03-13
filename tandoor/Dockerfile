ARG BUILD_FROM

FROM ${BUILD_FROM}

ARG ORIGINAL_ENTRYPOINT
ARG ORIGINAL_CMD

RUN echo "${ORIGINAL_ENTRYPOINT}" > /original-entrypoint && \
    echo "${ORIGINAL_CMD}" > /original-cmd

COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]