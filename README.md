# openclaw-shopify-manager

[ClawHub](https://clawhub.ai/skills/openclaw-shopify-manager) · [GitHub Releases](https://github.com/dave8172/openclaw-shopify-manager/releases) · [Project Page](https://dave8172-website.vercel.app/projects/openclaw-shopify-manager)

**Connect OpenClaw to Shopify with a guided setup, local secret storage, and safe read-first store access.**

`openclaw-shopify-manager` is a Shopify skill for OpenClaw. It helps you connect a Shopify store, complete OAuth, verify webhooks, and read or update store data through a small local connector.

## What you can do

- connect a Shopify store to OpenClaw
- complete Shopify OAuth and store the offline token locally
- verify Shopify callbacks and webhooks
- show store info
- list and inspect products
- find a product by title or ID
- read and update blog/article content
- run the connector on a host or as a Docker sidecar

## Why this setup is useful

- **guided setup** instead of manual file juggling
- **local secrets only**: `SHOPIFY_API_KEY`, `SHOPIFY_API_SECRET`, and `SHOPIFY_ACCESS_TOKEN` stay in `.env`
- **least-privilege friendly**: narrow scopes and read-first workflows
- **localhost-bound connector** by default
- **works with real deployment shapes**: host, VM, Docker, sidecar

## Before you start

You need:

- an OpenClaw instance
- a Shopify store or dev store
- a Shopify app with API key and secret
- a public HTTPS callback URL
- Node.js 22+

Recommended easiest path:

- connector on the host
- Tailscale on the host
- systemd on the host

## Quick start

### 1) Install the skill

Get the latest packaged skill from GitHub Releases or ClawHub.

### 2) Run the guided setup

```bash
node ./scripts/setup-runtime.mjs guided-setup --write-service
```

This creates the runtime directory:

```text
~/oc/shopify-runtime/
  config.json
  .env
  .gitignore
  shopify-connector.mjs
  shopify-connector.service
  state/
  logs/
```

Secrets stay in `.env`. The runtime `.gitignore` protects `.env`, `state/`, and `logs/`.

### 3) Configure your Shopify app

Use the values printed by the guided setup.

Typical values:

- **App URL**: `https://YOUR-HOST/shopify-manager`
- **Allowed redirection URL**: `https://YOUR-HOST/shopify-manager/shopify/callback`

### 4) Start the connector

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs run-server
curl http://127.0.0.1:8787/healthz
```

Expected response:

```text
ok
```

### 5) Expose HTTPS

Recommended with Tailscale:

```bash
tailscale serve --https=443 /shopify-manager http://127.0.0.1:8787
tailscale funnel --https=443 on
```

### 6) Complete OAuth

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs auth-url
```

Open the returned URL, approve the install, and let Shopify redirect back to your callback URL.

After success, the offline token is stored locally in `.env` as `SHOPIFY_ACCESS_TOKEN`.

### 7) Use Shopify commands

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs shop-info
node ./shopify-connector.mjs list-products --limit 10
node ./shopify-connector.mjs find-products --query "Winter Jacket" --limit 5
node ./shopify-connector.mjs get-product --title "Winter Jacket"
```

## Common Shopify tasks after setup

### Show store info

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs shop-info
```

### List products

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs list-products --limit 10
```

### Get product by ID

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs get-product --id gid://shopify/Product/1234567890
```

### Find product by title

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs find-products --query "Winter Jacket" --limit 5
```

### Get first matching product by title

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs get-product --title "Winter Jacket"
```

See also: `examples/post-setup-usage.md`

## Choose your deployment path

### Best default: host install

Use this if you want the simplest and most reliable path.

Recommended shape:
- connector on host
- systemd on host
- Tailscale on host

Host bootstrap helper:

```bash
bash ./skill/openclaw-shopify-manager/scripts/install-host-runtime.sh
```

### Good Docker default: OpenClaw in Docker, connector on host

Use this if OpenClaw already runs in Docker but you want the cleanest Shopify setup.

Recommended shape:
- OpenClaw in Docker
- connector on host
- Tailscale on host

### Containerized fallback: sidecar connector

Use this if you want the Shopify connector containerized too.

Files:
- compose: `examples/docker-compose.sidecar.yml`
- guide: `examples/docker-compose.sidecar.md`

Start it with:

```bash
docker compose -f examples/docker-compose.sidecar.yml up -d
```

## Security and secret handling

- keep `SHOPIFY_API_KEY` in `.env`
- keep `SHOPIFY_API_SECRET` in `.env`
- keep `SHOPIFY_ACCESS_TOKEN` in `.env`
- do not commit `.env`
- do not pass secrets around in docs, screenshots, or committed config
- keep the connector bound locally when possible

## Connector commands

Available commands:

- `auth-url`
- `exchange-code`
- `run-server`
- `test`
- `shop-info`
- `list-products`
- `find-products`
- `get-product`
- `update-product`
- `list-blogs`
- `list-articles`
- `create-article`
- `update-article`

## Troubleshooting

Run the doctor check:

```bash
node ./scripts/setup-runtime.mjs doctor
```

Use this to confirm:
- runtime files exist
- secrets are present locally
- callback URL matches public base URL
- runtime `.gitignore` is protecting `.env`, `state/`, and `logs/`
- Tailscale looks ready when you are using it

## Links

- ClawHub: <https://clawhub.ai/skills/openclaw-shopify-manager>
- GitHub releases: <https://github.com/dave8172/openclaw-shopify-manager/releases>
- Project page: <https://dave8172-website.vercel.app/projects/openclaw-shopify-manager>
