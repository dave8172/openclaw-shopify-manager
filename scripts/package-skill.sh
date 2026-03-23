#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$ROOT/skill/openclaw-shopify-manager"
DIST_DIR="$ROOT/dist"
SKILL_CREATOR_DIR="/usr/lib/node_modules/openclaw/skills/skill-creator/scripts"

mkdir -p "$DIST_DIR"
PYTHONPATH="$SKILL_CREATOR_DIR${PYTHONPATH:+:$PYTHONPATH}" \
  python3 "$SKILL_CREATOR_DIR/package_skill.py" "$SKILL_DIR" "$DIST_DIR"
