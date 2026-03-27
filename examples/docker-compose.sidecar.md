# Plug-and-play sidecar compose

Use this when OpenClaw runs in Docker and you want the Shopify connector as a dedicated sidecar.

## Files

- compose file: `docker-compose.sidecar.yml`
- runtime dir: `./shopify-runtime/`

## Fast path

1. Create the runtime on the host with the guided setup helper.
2. Keep secrets in `./shopify-runtime/.env` only.
3. Start the sidecar:

```bash
docker compose -f docker-compose.sidecar.yml up -d
```

4. Verify it:

```bash
docker compose -f docker-compose.sidecar.yml ps
docker compose -f docker-compose.sidecar.yml logs --tail=50 shopify-connector
curl http://127.0.0.1:8787/healthz
```

5. Expose HTTPS from the host:

```bash
tailscale serve --https=443 /shopify-manager http://127.0.0.1:8787
tailscale funnel --https=443 on
```

6. Complete OAuth and verify a read:

```bash
cd ./shopify-runtime
node ./shopify-connector.mjs auth-url
node ./shopify-connector.mjs shop-info
```

## Notes

- persist `config.json`, `.env`, `state/`, and `logs/`
- keep Tailscale on the host when possible
- do not try to use host-style systemd inside the sidecar
