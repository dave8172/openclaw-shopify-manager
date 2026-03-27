# Changelog

## v0.2.0

- add smoother post-setup usage examples for store info, list products, and get product by title or id
- add `find-products` and `get-product --title` support to the connector runtime
- add a canonical host installer helper script for host/systemd-oriented setups
- upgrade the sidecar compose example into a more plug-and-play starter with a dedicated guide

## v0.1.9

- add runtime `.gitignore` protection for `.env`, `state/`, and `logs/` during guided setup
- extend doctor checks to verify runtime `.gitignore` secret protection
- add clearer top-level secret-handling guidance in README/setup docs

## v0.1.8

- harden guided setup so Shopify secrets are prompted and stored in `.env` only by default
- keep `SHOPIFY_ACCESS_TOKEN` explicitly documented as `.env`-only local state
- remove secret-passing examples from the public setup flow and warn against CLI secret flags
- expand setup/doctor output with explicit secret-handling guidance

## v0.1.7

- tighten ClawHub-facing skill metadata so the listing matches the guided low-friction setup positioning
- keep GitHub and ClawHub versions aligned after the v0.1.6 productization release

## v0.1.6

- add a guided setup flow with `setup-runtime.mjs guided-setup`
- polish `setup-runtime.mjs doctor` with placeholder detection, callback consistency checks, and Tailscale readiness hints
- add a first-run success transcript and screenshot artifact
- rewrite README/setup flow around a canonical low-friction install → setup → done path
- align the skill docs around the new guided setup and validation flow

## v0.1.5

- tighten connector logging by storing webhook body checksum/size instead of full payload bodies
- remove one-time OAuth state after successful callback exchange
- narrow skill positioning toward least-privilege, localhost-bound behavior
- add explicit security/behavior documentation to reduce false-positive scanner interpretations
