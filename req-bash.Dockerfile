FROM debian:bookworm-slim

# Install system dependencies
RUN apt update && apt install -y --no-install-recommends \
    bash \
    bats \
    curl \
    xmlstarlet \
    jq \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Standard BATS entrypoint
ENTRYPOINT ["/usr/bin/bats"]
