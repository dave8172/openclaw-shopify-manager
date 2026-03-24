# openclaw-shopify-manager

Shopify skill for OpenClaw.

It gives OpenClaw a small Shopify connector runtime plus the docs and helper scripts needed to:

- connect a Shopify store with OAuth
- validate callbacks and webhooks
- expose the connector over HTTPS with Tailscale Serve/Funnel
- run the connector as a small long-lived backend with systemd
- handle Docker-shaped deployments without quietly breaking

## Status

Early but usable.

This repo is a maintainable starting point for a public OpenClaw Shopify skill, not a finished everything-platform. The current scope is deliberately conservative.

## What is included

### Installable skill

- `skill/openclaw-shopify-manager/`

Contains:

- `SKILL.md`
- Shopify connector runtime
- Tailscale/systemd helper scripts
- setup and safety references
- example config and service assets

### Maintainer files

- `scripts/package-skill.sh`
- `examples/`
- `dist/` for generated `.skill` packages

## Current capability

### Connector/runtime

- generate Shopify auth/install URL
- receive OAuth callback
- exchange offline token
- validate webhook HMAC
- expose a small local HTTP service
- make Shopify Admin GraphQL calls

### Read operations

- shop info
- list/get products
- list blogs
- list articles

### Conservative write operations

- update product fields
- create article
- update article

## Deployment models

### Recommended

1. **Host/VM**
   - connector on host
   - systemd on host
   - Tailscale on host

2. **OpenClaw in Docker, connector on host**
   - usually the cleanest Docker setup

3. **OpenClaw in Docker, connector sidecar container**
   - valid if you want a more containerized layout

### Not recommended except for experiments

- OpenClaw and the Shopify connector crammed into one container

## Why Tailscale is part of this

Shopify needs a stable public HTTPS callback/webhook destination.

For many OpenClaw users, Tailscale Serve/Funnel is the simplest production-friendly way to get there without introducing a separate reverse proxy stack.

This skill includes guidance for:

- checking whether Tailscale is installed
- guiding users through Tailscale-based exposure
- mapping a public path prefix to the local Shopify connector

## Quick install

### Install from release asset

1. Download `openclaw-shopify-manager.skill` from the latest GitHub release.
2. Import/install it into your OpenClaw skills setup using your normal skill installation flow.
3. Use the bundled assets/scripts to scaffold a runtime directory for the Shopify connector.

### Local maintainer/dev install

```bash
git clone https://github.com/dave8172/openclaw-shopify-manager.git
cd openclaw-shopify-manager
npm run check
./scripts/package-skill.sh
```

Output:

- `dist/openclaw-shopify-manager.skill`

## Package the skill

```bash
./scripts/package-skill.sh
```

Output:

- `dist/openclaw-shopify-manager.skill`

## Repo layout

- `skill/openclaw-shopify-manager/` — packaged skill contents
- `scripts/package-skill.sh` — packaging helper
- `examples/` — maintainer examples and deployment notes
- `dist/` — generated `.skill` packages

## First-time maintainer workflow

1. edit skill/runtime files
2. run checks (`npm run check`)
3. test on a clean OpenClaw install
4. commit changes
5. tag a release
6. attach the `.skill` package to the GitHub release

## Safety stance

- keep secrets out of git
- keep Shopify secrets in `.env`
- prefer least-privilege scopes
- default to confirmation before mutations
- prefer host/sidecar deployment over clever container hacks

## Near-term roadmap

- add clean install walkthrough for a fresh machine
- add one fully tested Docker sidecar walkthrough
- add more Shopify operations carefully, not indiscriminately
- smoke-test against a dedicated dev store before each release

- add clean install walkthrough for a fresh machine
- add one fully tested Docker sidecar walkthrough
- add more Shopify operations carefully, not indiscriminately
- smoke-test against a dedicated dev store before each release
