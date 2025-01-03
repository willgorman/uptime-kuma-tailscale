#!/bin/bash

if [ -n "$TAILSCALE_AUTHKEY" ]; then
  echo "Starting Tailscale daemon..."
  /app/tailscaled --statedir==/app/data/tailscale_state \
    --state=/app/data/tailscale_state/tailscaled.state \
    --socket=/var/run/tailscale/tailscaled.sock \
    --socks5-server=localhost:1055 \
    --outbound-http-proxy-listen=localhost:1055 &

  TAILSCALE_ARGS="--authkey=$TAILSCALE_AUTHKEY --hostname=${TAILSCALE_HOSTNAME:-uptime-kuma}"

  if [ "${TAILSCALE_EXITNODE:-false}" = "true" ]; then
    echo "Configuring as exit node..."
    TAILSCALE_ARGS="$TAILSCALE_ARGS --advertise-exit-node"
  fi

  until /app/tailscale up $TAILSCALE_ARGS; do
    echo "Waiting for Tailscale to be ready..."
    sleep 5
  done
else
  echo "TAILSCALE_AUTHKEY not set, skipping Tailscale setup"
fi

if [ "$ONLY_TAILSCALE" = "true" ]; then
  echo "Using Tailscale IP for Uptime Kuma"
  export HOST=$(/app/tailscale ip | head -n 1)
  /app/tailscale serve / proxy 80
else
  echo "Using default host for Uptime Kuma"
  export HOST="0.0.0.0"
fi

cd /app && node server/server.js --port 80 --host $HOST
