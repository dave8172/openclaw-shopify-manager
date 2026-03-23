# systemd

## Why use systemd

Use systemd when the Shopify connector must keep running for callbacks, webhooks, and operational reliability.

This guide applies to host and VM deployments. If the connector runs in Docker, use your container runtime instead of trying to force normal systemd service management into the container.

Benefits:

- survives shell disconnects
- starts on boot
- easy `start|stop|restart|status`
- logs available via `journalctl`

## Service model

The bundled service template runs the connector with:

- working directory set to the runtime root
- env file loaded from `.env`
- restart policy enabled
- local bind only

Use `assets/shopify-connector.service` as the template.

## Lifecycle helper

Use `scripts/shopify-systemd.sh`:

- `install` — copy service file and reload systemd
- `start`
- `stop`
- `restart`
- `status`
- `logs`

The script supports overriding:

- `SERVICE_NAME`
- `RUNTIME_ROOT`
- `SERVICE_FILE_SOURCE`

## Typical flow

1. Prepare runtime root with config and `.env`
2. Adjust the service template if needed
3. Install the service
4. Start it
5. Verify local `healthz`
6. Expose with Tailscale Serve/Funnel if desired

## Logging

For recent logs:

```bash
journalctl -u shopify-connector.service -n 100 --no-pager
```

Or use the helper script `logs` command.

## Common failure points

- wrong working directory
- wrong path to the connector script
- `.env` missing required Shopify values
- callback URL mismatch with Shopify app settings
- service running, but public path not exposed
