FROM golang:1.23.5-bookworm AS build

ARG TARGETARCH
ARG TARGETOS

# Set the upx version
ARG upx_version=4.2.4

# Install UPX and cleanup
RUN apt-get update && apt-get install -y --no-install-recommends xz-utils && \
  case "$TARGETARCH" in \
    amd64|arm64) ;; \
    *) echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
  esac && \
  curl -Ls https://github.com/upx/upx/releases/download/v${upx_version}/upx-${upx_version}-${TARGETARCH}_linux.tar.xz -o - | tar xvJf - -C /tmp && \
  cp /tmp/upx-${upx_version}-${TARGETARCH}_linux/upx /usr/local/bin/ && \
  chmod +x /usr/local/bin/upx && \
  apt-get remove -y xz-utils && \
  rm -rf /var/lib/apt/lists/*
