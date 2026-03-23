#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RUNTIME_ROOT="${1:-$HOME/oc/shopify-runtime}"

mkdir -p "$RUNTIME_ROOT" "$RUNTIME_ROOT/state" "$RUNTIME_ROOT/logs"
install -m 0755 "$SKILL_ROOT/scripts/shopify-connector.mjs" "$RUNTIME_ROOT/shopify-connector.mjs"
install -m 0644 "$SKILL_ROOT/assets/config.example.json" "$RUNTIME_ROOT/config.json.example"
install -m 0644 "$SKILL_ROOT/assets/env.example" "$RUNTIME_ROOT/.env.example"
install -m 0644 "$SKILL_ROOT/assets/shopify-connector.service" "$RUNTIME_ROOT/shopify-connector.service"

if [ ! -f "$RUNTIME_ROOT/config.json" ]; then
  cp "$RUNTIME_ROOT/config.json.example" "$RUNTIME_ROOT/config.json"
fi

if [ ! -f "$RUNTIME_ROOT/.env" ]; then
  cp "$RUNTIME_ROOT/.env.example" "$RUNTIME_ROOT/.env"
fi

echo "Runtime scaffold installed at: $RUNTIME_ROOT"
echo "Next: edit config.json and .env, then start the connector or install the systemd service."
