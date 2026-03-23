# openclaw-shopify-manager

Git-friendly source repo for the `openclaw-shopify-manager` OpenClaw skill.

## What this is

This repo contains:

- an installable OpenClaw skill under `skill/openclaw-shopify-manager/`
- reusable helper scripts bundled with the skill
- reference docs for Shopify, Tailscale, systemd, and Docker-shaped deployments
- example deployment assets

## Repo layout

- `skill/openclaw-shopify-manager/` — the actual skill folder that gets packaged
- `dist/` — generated `.skill` packages
- `scripts/package-skill.sh` — package helper
- `examples/` — optional reference examples for maintainers

## Package the skill

```bash
./scripts/package-skill.sh
```

Output:

- `dist/openclaw-shopify-manager.skill`

## Notes

- Keep secrets out of git.
- Put runtime secrets in `.env` files on the target host or mounted runtime volume.
- For Docker-based OpenClaw installs, prefer running the Shopify connector on the host or as a sidecar container.
- The packaged skill is intentionally lean; human-facing repo docs live outside the skill folder.
