# =========================
# Builder stage
# =========================
FROM debian:12-slim AS builder

ARG CLAMAV_VERSION=1.4.1

ENV DEBIAN_FRONTEND=noninteractive
ENV CARGO_HOME=/opt/rust/cargo \
    RUSTUP_HOME=/opt/rust/rustup \
    PATH=/opt/rust/cargo/bin:$PATH

# 1) Install build tools + ClamAV deps (from Ubuntu/Debian section)
RUN apt-get update && \
    apt-get install -y \
      gcc make pkg-config python3 python3-pip python3-pytest valgrind cmake \
      check libbz2-dev libcurl4-openssl-dev libjson-c-dev libmilter-dev \
      libncurses5-dev libpcre2-dev libssl-dev libxml2-dev zlib1g-dev \
      curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 2) Install Rust toolchain (recommended in docs)
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y --profile minimal && \
    rustc --version && cargo --version

WORKDIR /tmp

# 3) Download and build ClamAV from source (Linux distribution-style build)
RUN curl -L "https://www.clamav.net/downloads/production/clamav-${CLAMAV_VERSION}.tar.gz" -o clamav.tar.gz && \
    tar xzf clamav.tar.gz && \
    cd "clamav-${CLAMAV_VERSION}" && \
    mkdir build && cd build && \
    cmake .. \
      -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_INSTALL_LIBDIR=lib \
      -D APP_CONFIG_DIRECTORY=/etc/clamav \
      -D DATABASE_DIRECTORY=/var/lib/clamav \
      -D ENABLE_JSON_SHARED=OFF && \
    cmake --build . && \
    cmake --build . --target install

# =========================
# Runtime stage
# =========================
FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

# Runtime shared libs for ClamAV
RUN apt-get update && \
    apt-get install -y \
      libbz2-1.0 libcurl4 libjson-c5 libmilter1.0.1 libncurses5 \
      libpcre2-8-0 libssl3 libxml2 zlib1g ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy installed ClamAV from builder
COPY --from=builder /usr /usr
COPY --from=builder /etc/clamav /etc/clamav

# Create clamav user & fix ownership
RUN useradd -r -d /var/lib/clamav -s /usr/sbin/nologin clamav && \
    mkdir -p /var/lib/clamav /var/log/clamav /var/run/clamav && \
    chown -R clamav:clamav /var/lib/clamav /var/log/clamav /var/run/clamav

EXPOSE 3310

LABEL org.opencontainers.image.description="ClamAV antivirus engine built from source with freshclam and clamd"
LABEL org.opencontainers.image.licenses="GPL-2.0-only"
LABEL org.opencontainers.image.source="https://github.com/Cisco-Talos/clamav"

COPY --from=builder /usr/share/common-licenses/GPL-2 /licenses/GPL-2.0

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY clamd.conf /etc/clamav/clamd.conf
COPY freshclam.conf /etc/clamav/freshclam.conf

ENTRYPOINT ["/entrypoint.sh"]

USER clamav
# Default: run clamd in foreground using distro-style config location
CMD ["clamd", "--foreground", "--config-file=/etc/clamav/clamd.conf"]
