# openclaw-shopify-manager

`openclaw-shopify-manager` is an OpenClaw skill for connecting OpenClaw to a Shopify store.

It gives you a small Shopify connector runtime plus setup guidance for exposing a stable HTTPS callback/webhook endpoint, usually with Tailscale Serve/Funnel.

## What this skill does

This skill helps OpenClaw:

- connect a Shopify app with OAuth
- receive the Shopify callback and store the offline token locally
- validate incoming Shopify webhooks
- run a small backend endpoint for Shopify integration
- guide setup for Tailscale exposure
- guide setup for systemd service control on host/VM installs
- handle Docker-shaped deployments without assuming everything runs on bare metal

## What you can use it for

Current scope includes:

- Shopify auth/install flow
- shop info lookup
- product read/update helpers
- blog/article read/create/update helpers
- connector start/stop/status/logs guidance
- deployment guidance for host, Tailscale, systemd, and Docker sidecars

## How it works

The skill bundles a small connector script that runs locally and does three main jobs:

1. generate the Shopify OAuth install URL
2. accept the Shopify callback and exchange the code for an offline token
3. accept and validate Shopify webhooks

The connector is meant to run as a small local service.

Typical production flow:

- connector runs locally on `127.0.0.1:8787`
- Tailscale Serve/Funnel exposes it at a stable HTTPS path
- Shopify sends the callback/webhooks to that public HTTPS URL
- OpenClaw uses the saved token for Shopify Admin API actions

## Requirements

You will generally want:

- an OpenClaw instance
- Node.js 22+
- bash
- python3
- a Shopify app with API key and secret
- a stable public HTTPS callback URL

For the easiest production-friendly setup, use:

- Tailscale on the host
- the connector on the host or in a dedicated sidecar

## Recommended deployment modes

## 1) Best default: host or VM deployment

Use this if OpenClaw runs directly on a machine or VM.

Recommended shape:

- connector on host
- systemd on host
- Tailscale on host

Why this is best:

- simplest service management
- easiest Tailscale setup
- clear local vs public networking

## 2) OpenClaw in Docker, connector on host

Use this if OpenClaw is containerized but you still want the simplest reliable Shopify setup.

Recommended shape:

- OpenClaw in Docker
- Shopify connector on host
- Tailscale on host

Why this is good:

- avoids forcing systemd into containers
- avoids awkward Tailscale-in-container setups
- keeps callback/webhook networking easier to reason about

## 3) OpenClaw in Docker, connector as sidecar

Use this if you want a more containerized deployment.

Recommended shape:

- OpenClaw in one container
- Shopify connector in a second container
- Tailscale or reverse proxy on the host
- persistent mounted volume for connector state/logs/config

## Not recommended

- cramming OpenClaw, Shopify connector, and Tailscale into one general-purpose container unless you are just experimenting

## Install

## Install the skill

1. Download `openclaw-shopify-manager.skill` from the latest release:
   - <https://github.com/dave8172/openclaw-shopify-manager/releases>
2. Import/install it using your normal OpenClaw skill installation flow.
3. If you want to inspect or reuse the bundled runtime files directly, extract the package locally. A `.skill` file is just a zip archive:

```bash
mkdir -p ~/oc/shopify-skill-src
unzip openclaw-shopify-manager.skill -d ~/oc/shopify-skill-src
```

After extraction, the bundled files will be under:

```text
~/oc/shopify-skill-src/openclaw-shopify-manager/
  assets/
  scripts/
  references/
  SKILL.md
```

4. Create a runtime directory for the connector, for example:

```bash
mkdir -p ~/oc/shopify-runtime/{state,logs}
```

5. Copy the bundled runtime files you need into that runtime directory:

```bash
cp ~/oc/shopify-skill-src/openclaw-shopify-manager/scripts/shopify-connector.mjs ~/oc/shopify-runtime/
cp ~/oc/shopify-skill-src/openclaw-shopify-manager/assets/config.example.json ~/oc/shopify-runtime/config.json
cp ~/oc/shopify-skill-src/openclaw-shopify-manager/assets/env.example ~/oc/shopify-runtime/.env
cp ~/oc/shopify-skill-src/openclaw-shopify-manager/assets/shopify-connector.service ~/oc/shopify-runtime/
```

6. Fill in your Shopify app credentials and callback URL.
7. Start the connector.
8. Expose it over HTTPS.
9. Run the OAuth install flow.

## Minimal host setup

Example host runtime layout:

```text
~/oc/shopify-runtime/
  config.json
  .env
  shopify-connector.mjs
  shopify-connector.service
  state/
  logs/
```

Example setup flow after extracting the `.skill` package:

```bash
mkdir -p ~/oc/shopify-runtime/{state,logs}
cp ~/oc/shopify-skill-src/openclaw-shopify-manager/assets/config.example.json ~/oc/shopify-runtime/config.json
cp ~/oc/shopify-skill-src/openclaw-shopify-manager/assets/env.example ~/oc/shopify-runtime/.env
cp ~/oc/shopify-skill-src/openclaw-shopify-manager/assets/shopify-connector.service ~/oc/shopify-runtime/
cp ~/oc/shopify-skill-src/openclaw-shopify-manager/scripts/shopify-connector.mjs ~/oc/shopify-runtime/
```

Edit:

- `~/oc/shopify-runtime/config.json`
- `~/oc/shopify-runtime/.env`

Then start the connector manually for first verification:

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs run-server
```

Expected local health check:

```bash
curl http://127.0.0.1:8787/healthz
```

Expected response:

```text
ok
```

If you want long-lived service management, install the systemd service and use normal start/stop/status operations.

## Minimal Docker sidecar setup

If OpenClaw runs in Docker, a sidecar connector is often cleaner than forcing everything into one container.

Example Compose service:

```yaml
services:
  shopify-connector:
    image: node:22-bookworm-slim
    working_dir: /runtime
    command: ["node", "/runtime/shopify-connector.mjs", "run-server"]
    volumes:
      - ./shopify-runtime:/runtime
    restart: unless-stopped
    ports:
      - "127.0.0.1:8787:8787"
```

Suggested sidecar runtime directory:

```text
./shopify-runtime/
  config.json
  .env
  shopify-connector.mjs
  state/
  logs/
```

Important notes:

- persist `config.json`, `.env`, `state/`, and `logs/`
- prefer Tailscale on the host
- do not rely on systemd inside the container
- make sure the public callback path matches Shopify exactly

## Shopify app setup guide

Before the connector can work, you need a Shopify app with a client ID and client secret.

### What values you need from Shopify

You will usually need these four things:

- **Client ID / API key** → `SHOPIFY_API_KEY`
- **Client secret / API secret** → `SHOPIFY_API_SECRET`
- **Store domain** → `SHOPIFY_SHOP`
- **App callback URL** → `SHOPIFY_REDIRECT_URI`

### Important distinction: store domain vs callback URL

These are different values:

- **Store domain**: your Shopify shop domain, usually something like `your-store.myshopify.com`
- **Callback URL**: your public HTTPS connector URL, something like `https://YOUR-TAILSCALE-HOSTNAME/shopify-manager/shopify/callback`

Do not put your Tailscale URL into `SHOPIFY_SHOP`.
Do not put your `myshopify.com` store domain into `SHOPIFY_REDIRECT_URI`.

### How to create the Shopify app

In Shopify, app dashboard labels move around a bit over time, but the flow is usually:

1. Log in to the Shopify admin for the store you want to connect.
2. Go to **Settings**.
3. Open **Apps and sales channels**.
4. Open **Develop apps**.
   - If app development is not enabled yet, Shopify will ask you to allow custom app development for the store.
5. Click **Create an app**.
6. Give it a name like `OpenClaw Shopify Manager`.
7. Create the app.

### Configure Admin API scopes

Inside the app configuration:

1. Open **Configuration** or **API access**.
2. Find **Admin API integration**.
3. Select only the scopes you actually need.

For a reasonable starting point with this skill, use only what matches your workflow. Common examples:

- `read_products`
- `write_products`
- `read_content`
- `write_content`
- `read_orders`

Avoid broad scopes you do not need.

### Set the app URL and redirect URL

Inside the app setup screen, set:

- **App URL**: your public connector base URL
- **Allowed redirection URL(s)**: your public callback URL

Example with Tailscale:

- App URL: `https://YOUR-TAILSCALE-HOSTNAME/shopify-manager`
- Redirect URL: `https://YOUR-TAILSCALE-HOSTNAME/shopify-manager/shopify/callback`

If Shopify allows multiple redirect URLs, keep the exact production callback URL listed there.

### Get the client ID and secret

After the app is created and configured:

1. Open the app overview or API credentials area.
2. Copy the app's **Client ID** / **API key**.
3. Reveal and copy the **Client secret** / **API secret**.
4. Put them into your runtime `.env` file.

Example:

```bash
SHOPIFY_API_KEY=your_client_id_here
SHOPIFY_API_SECRET=your_client_secret_here
```

### Where to find the Shopify store domain

For `SHOPIFY_SHOP`, you want the store's Shopify domain, usually the `*.myshopify.com` domain.

Common ways to find it:

#### Option 1: Browser URL

When you are inside Shopify admin, the browser URL typically includes the store domain, for example:

```text
https://admin.shopify.com/store/your-store-name
```

That storefront slug is not always the final value you should use directly, so verify the real store domain in Shopify settings.

#### Option 2: Settings → Domains

In Shopify admin:

1. Go to **Settings**.
2. Open **Domains**.
3. Look for the Shopify-managed domain, usually ending in `.myshopify.com`.

That is usually the safest value to use for:

```bash
SHOPIFY_SHOP=your-store.myshopify.com
```

#### Option 3: Store details / app setup context

Some Shopify screens also show the store's default Shopify domain in store details or app install context. If available, prefer the `*.myshopify.com` domain over any branded custom storefront domain.

### Which domain should you use in `SHOPIFY_SHOP`?

Use the Shopify shop domain, usually:

```text
your-store.myshopify.com
```

Do **not** use:

- your branded storefront domain, like `store.example.com`
- your Tailscale URL
- your callback URL

### Final values checklist

Before running the OAuth install flow, verify these values:

```bash
SHOPIFY_SHOP=your-store.myshopify.com
SHOPIFY_API_KEY=...
SHOPIFY_API_SECRET=...
SHOPIFY_PUBLIC_BASE_URL=https://YOUR-TAILSCALE-HOSTNAME/shopify-manager
SHOPIFY_REDIRECT_URI=https://YOUR-TAILSCALE-HOSTNAME/shopify-manager/shopify/callback
```

If these are wrong, the install flow will be annoying in exactly the least fun way.

## Tailscale setup pattern

A common path-prefix setup is:

- OpenClaw stays on `/`
- Shopify connector is exposed on `/shopify-manager`

If the connector listens on `127.0.0.1:8787`, the host can expose it like this:

```bash
tailscale serve --https=443 /shopify-manager http://127.0.0.1:8787
tailscale funnel --https=443 on
```

Then verify:

```bash
curl -I https://YOUR-TAILSCALE-HOSTNAME/shopify-manager/healthz
```

Your Shopify app values should then usually look like:

- App URL: `https://YOUR-TAILSCALE-HOSTNAME/shopify-manager`
- Redirect URL: `https://YOUR-TAILSCALE-HOSTNAME/shopify-manager/shopify/callback`
- Webhook base: `https://YOUR-TAILSCALE-HOSTNAME/shopify-manager/shopify/webhooks`

## Running the OAuth install flow

Once your config is filled and the connector is reachable:

Generate the auth URL:

```bash
node ./shopify-connector.mjs auth-url
```

Open the returned URL in a browser, approve the app install, and let Shopify redirect back to your configured callback URL.

After a successful callback, the connector stores the offline token locally in `.env`.

## Verifying the connection

Use a read-only check first:

```bash
node ./shopify-connector.mjs shop-info
```

You can also test the basic connection with:

```bash
node ./shopify-connector.mjs test
```

## Safety notes

- keep Shopify secrets out of git
- keep the connector bound locally when possible
- prefer least-privilege Shopify scopes
- confirm store-changing operations before using them
- use host/sidecar deployment over clever all-in-one container setups

## Where to get the packaged skill

Releases:

- <https://github.com/dave8172/openclaw-shopify-manager/releases>

## Current limitations

This is still an early release.

Current design is intentionally conservative:

- strongest support today is setup/auth/runtime/deployment flow
- Shopify operation coverage is limited on purpose
- broad store automation is not bundled yet

That is deliberate. Better a narrow tool that behaves than a sprawling one that trashes a live store.
