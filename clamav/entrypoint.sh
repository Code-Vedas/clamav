#!/usr/bin/env bash
set -euo pipefail

echo "[clamav] Starting entrypoint..."

# Ensure runtime directories exist
mkdir -p /var/lib/clamav /var/log/clamav /var/run/clamav

# Fix ownership (in case of mounted volumes)
chown -R clamav:clamav /var/lib/clamav /var/log/clamav /var/run/clamav

# If main DB files are missing, run initial update
if [ ! -f /var/lib/clamav/main.cvd ] && [ ! -f /var/lib/clamav/main.cld ]; then
  echo "[clamav] No virus DB found — running initial freshclam..."
  freshclam || true
else
  echo "[clamav] Virus DB already present — skipping initial download"
fi

echo "[clamav] Starting clamd..."
exec clamd --foreground --config-file=/etc/clamav/clamd.conf
