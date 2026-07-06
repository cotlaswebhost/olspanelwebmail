#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${OLSPANEL_BASE_DIR:-/usr/local/olspanel/mypanel}"
PLUGIN_DIR="$BASE_DIR/plugin"
PARTY_DIR="$BASE_DIR/3rdparty"
ICON_DIR="$BASE_DIR/media/icon"
SNAPPY_DIR="$PARTY_DIR/snappymail"
SOGO_DIR="$PARTY_DIR/sogo"

FORCE="${1:-}"

confirm_uninstall() {
  if [[ "$FORCE" == "--yes" ]]; then
    return 0
  fi

  echo "This will remove Snappymail/SOGo plugin files from: $BASE_DIR"
  echo "Run with --yes to confirm non-interactively."
  read -r -p "Continue uninstall? [y/N]: " reply
  case "$reply" in
    y|Y|yes|YES)
      return 0
      ;;
    *)
      echo "Uninstall cancelled."
      exit 0
      ;;
  esac
}

require_base_dir() {
  if [[ ! -d "$BASE_DIR" ]]; then
    echo "ERROR: OLSPanel base directory not found: $BASE_DIR" >&2
    exit 1
  fi
}

uninstall_plugin_files() {
  rm -f "$PLUGIN_DIR/snappymail.conf" "$PLUGIN_DIR/sogo.conf"
  rm -rf "$SNAPPY_DIR" "$SOGO_DIR"
  rm -f "$ICON_DIR/snappymail.png" "$ICON_DIR/sogo.svg"
}

require_base_dir
confirm_uninstall
uninstall_plugin_files

systemctl restart cp || true
echo "Snappymail + SOGo plugin bridge removed from OLSPanel: $BASE_DIR"
