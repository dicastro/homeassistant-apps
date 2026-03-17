FROM ubuntu:latest

# Install system tools and skopeo
RUN apt update && \
    apt install -y bash ca-certificates curl wget jq git skopeo && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && \
    chmod +x /usr/bin/yq

ENTRYPOINT ["/bin/bash"]