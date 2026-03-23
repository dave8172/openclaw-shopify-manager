# Docker notes

Recommended order of preference:

1. OpenClaw in Docker, connector on host, Tailscale on host
2. OpenClaw in Docker, connector sidecar container, Tailscale on host
3. Everything in one container only for experiments

Why:

- systemd is a host concern
- Tailscale is usually cleaner on the host
- Shopify callback URLs are easier to reason about when one service owns the public path
