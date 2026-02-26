#!/usr/bin/env bash

# Reload configuration
source /config.saved
set -x

echo "Waiting for Tailscale to start up momentarily..."
sleep 15

if [[ $TAILSCALE_AUTHKEY == "" ]] && [[ $TAILSCALE_AUTH_ONCE != "true" ]]; then
  if ! tailscale status > /dev/null 2>&1; then
    echo "Either TAILSCALE_AUTHKEY isn't set or haven't authed in a past run, skipping..."
    exit 0
  fi
fi

if [[ $TAILSCALE_AUTH_ONCE == "true" ]]; then
  true
else
  tailscale up --hostname"${TAILSCALE_HOSTNAME}" --auth-key "${TAILSCALE_AUTHKEY}" || echo "Login failed, aborting..." && exit 0
fi

tailscale set --accept-routes
tailscale funnel --bg --https 443 127.0.0.1:80
