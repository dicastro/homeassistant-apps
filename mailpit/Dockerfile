ARG BUILD_FROM=ghcr.io/axllent/mailpit:v1.29.3

FROM $BUILD_FROM

COPY run.sh /
COPY original-entrypoint /
COPY original-cmd /

RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]