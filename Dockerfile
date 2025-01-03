FROM louislam/uptime-kuma:beta-slim as uptime-kuma

FROM node:22-bookworm
WORKDIR /app

RUN apt-get update && \
  apt-get install -y \
  ca-certificates \
  iptables \
  iputils-ping \
  && rm -rf /var/lib/apt/lists/*

# Copy uptime-kuma files
COPY --from=uptime-kuma /app /app

# Copy Tailscale binaries from official image
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale

# Setup Tailscale directories
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /app/data/tailscale_state

# Configure IP forwarding
RUN echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf && \
  echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.conf

COPY start.sh /app/
RUN chmod +x /app/start.sh

EXPOSE 80
CMD ["/app/start.sh"]