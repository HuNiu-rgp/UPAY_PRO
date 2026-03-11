#!/bin/sh
set -eu

mkdir -p /app/upay_pro/logs /app/upay_pro/DBS /data

redis-server \
  --bind 0.0.0.0 \
  --port "${UPAY_REDIS_PORT:-6379}" \
  --dir /data \
  --appendonly yes \
  --daemonize yes

exec /app/upay_pro/upay_pro -p "${UPAY_HTTP_PORT:-8090}"
