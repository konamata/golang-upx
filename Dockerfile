FROM golang:1.23.2-bookworm AS build

# Set the upx version
ARG upx_version=4.2.4

# Install upx and cleanup
RUN apt-get update && apt-get install -y --no-install-recommends xz-utils && \
  arch=$(uname -m) && \
  case "$arch" in \
    x86_64) TARGETARCH=amd64 ;; \
    aarch64) TARGETARCH=arm64 ;; \
    *) echo "Unsupported architecture: $arch" && exit 1 ;; \
  esac && \
  curl -Ls https://github.com/upx/upx/releases/download/v${upx_version}/upx-${upx_version}-${TARGETARCH}_linux.tar.xz -o - | tar xvJf - -C /tmp && \
  cp /tmp/upx-${upx_version}-${TARGETARCH}_linux/upx /usr/local/bin/ && \
  chmod +x /usr/local/bin/upx && \
  apt-get remove -y xz-utils && \
  rm -rf /var/lib/apt/lists/*
