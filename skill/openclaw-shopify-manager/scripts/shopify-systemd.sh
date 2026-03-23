#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:-}"
SERVICE_NAME="${SERVICE_NAME:-shopify-connector.service}"
RUNTIME_ROOT="${RUNTIME_ROOT:-$HOME/oc/shopify-runtime}"
SERVICE_FILE_SOURCE="${SERVICE_FILE_SOURCE:-$RUNTIME_ROOT/shopify-connector.service}"
SYSTEMD_DIR="/etc/systemd/system"
TARGET_FILE="$SYSTEMD_DIR/$SERVICE_NAME"

usage() {
  cat <<EOF
Usage: shopify-systemd.sh install|start|stop|restart|status|logs

Environment overrides:
  SERVICE_NAME
  RUNTIME_ROOT
  SERVICE_FILE_SOURCE
EOF
}

require_systemctl() {
  command -v systemctl >/dev/null 2>&1 || {
    echo "systemctl not found" >&2
    exit 1
  }
}

case "$ACTION" in
  install)
    require_systemctl
    [ -f "$SERVICE_FILE_SOURCE" ] || {
      echo "Service file not found: $SERVICE_FILE_SOURCE" >&2
      exit 1
    }
    sudo install -m 0644 "$SERVICE_FILE_SOURCE" "$TARGET_FILE"
    sudo systemctl daemon-reload
    sudo systemctl enable "$SERVICE_NAME"
    echo "Installed $SERVICE_NAME"
    ;;
  start)
    require_systemctl
    sudo systemctl start "$SERVICE_NAME"
    sudo systemctl --no-pager --full status "$SERVICE_NAME" || true
    ;;
  stop)
    require_systemctl
    sudo systemctl stop "$SERVICE_NAME"
    sudo systemctl --no-pager --full status "$SERVICE_NAME" || true
    ;;
  restart)
    require_systemctl
    sudo systemctl restart "$SERVICE_NAME"
    sudo systemctl --no-pager --full status "$SERVICE_NAME" || true
    ;;
  status)
    require_systemctl
    systemctl --no-pager --full status "$SERVICE_NAME" || true
    ;;
  logs)
    require_systemctl
    journalctl -u "$SERVICE_NAME" -n 100 --no-pager || true
    ;;
  *)
    usage
    exit 1
    ;;
esac
