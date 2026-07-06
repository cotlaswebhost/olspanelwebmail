#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

BASE_DIR="${OLSPANEL_BASE_DIR:-/usr/local/olspanel/mypanel}"
PLUGIN_DIR="$BASE_DIR/plugin"
PARTY_DIR="$BASE_DIR/3rdparty"
ICON_DIR="$BASE_DIR/media/icon"
SNAPPY_DIR="$PARTY_DIR/snappymail"
SOGO_DIR="$PARTY_DIR/sogo"
TMP_DIR="$(mktemp -d)"

cleanup() {
	rm -rf "$TMP_DIR"
}
trap cleanup EXIT

require_olspanel_paths() {
	if [[ ! -d "$BASE_DIR" ]]; then
		echo "ERROR: OLSPanel base directory not found: $BASE_DIR" >&2
		exit 1
	fi
	mkdir -p "$PLUGIN_DIR" "$PARTY_DIR" "$ICON_DIR" "$SNAPPY_DIR" "$SOGO_DIR"
}

download_snappymail_archive() {
	local archive="$1"
	local api_url="https://api.github.com/repos/the-djmaze/snappymail/releases/latest"
	local github_tar=""

	if curl -fL --connect-timeout 10 --max-time 90 https://snappymail.eu/repository/latest.tar.gz -o "$archive"; then
		return 0
	fi

	github_tar="$(curl -fsSL --connect-timeout 10 --max-time 45 "$api_url" \
		| grep -oE 'https://github.com/the-djmaze/snappymail/releases/download/[^\"]+\.tar\.gz' \
		| grep -v '\.asc$' \
		| grep -vi 'cpanel' \
		| head -n 1 || true)"

	if [[ -n "$github_tar" ]] && curl -fL --connect-timeout 10 --max-time 90 "$github_tar" -o "$archive"; then
		return 0
	fi

	echo "ERROR: Failed to download Snappymail archive from all known sources." >&2
	return 1
}

install_snappymail() {
	local archive="$TMP_DIR/snappymail-latest.tar.gz"
	local extract_dir="$TMP_DIR/snappymail-src"
	local top_dir=""
	local app_dir=""

	rm -rf "$SNAPPY_DIR"/*
	download_snappymail_archive "$archive"

	mkdir -p "$extract_dir"
	tar -xzf "$archive" -C "$extract_dir"

	top_dir="$(find "$extract_dir" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
	if [[ -z "$top_dir" ]]; then
		top_dir="$extract_dir"
	fi

	app_dir="$top_dir"
	if [[ -d "$top_dir/local/cpanel/base/3rdparty/snappymail" ]]; then
		app_dir="$top_dir/local/cpanel/base/3rdparty/snappymail"
	elif [[ -d "$top_dir/cpanel/base/3rdparty/snappymail" ]]; then
		app_dir="$top_dir/cpanel/base/3rdparty/snappymail"
	fi

	cp -a "$app_dir"/. "$SNAPPY_DIR"/
	cp -f "$REPO_ROOT/3rdparty/snappymail/auto_index.php" "$SNAPPY_DIR/auto_index.php"
	cp -f "$REPO_ROOT/plugin/snappymail.conf" "$PLUGIN_DIR/snappymail.conf"

	if ! curl -fsSL --connect-timeout 10 --max-time 45 "https://www.cloudron.io/store/icons/snappymail.png" -o "$ICON_DIR/snappymail.png"; then
		echo "WARNING: Could not fetch Snappymail icon from cloudron." >&2
	fi

	find "$SNAPPY_DIR" -type d -exec chmod 755 {} \;
	find "$SNAPPY_DIR" -type f -exec chmod 644 {} \;
}

install_sogo_bridge() {
	cp -f "$REPO_ROOT/3rdparty/sogo/auto_index.php" "$SOGO_DIR/auto_index.php"
	cp -f "$REPO_ROOT/plugin/sogo.conf" "$PLUGIN_DIR/sogo.conf"

	if ! curl -fsSL --connect-timeout 10 --max-time 45 "https://www.sogo.nu/img/sogo.svg" -o "$ICON_DIR/sogo.svg"; then
		echo "WARNING: Could not fetch SOGo icon from sogo.nu." >&2
	fi

	chmod 644 "$SOGO_DIR/auto_index.php" "$PLUGIN_DIR/sogo.conf" 2>/dev/null || true
}

require_olspanel_paths
install_snappymail
install_sogo_bridge

if command -v apt-cache >/dev/null 2>&1 && apt-cache show sogo >/dev/null 2>&1; then
	echo "SOGo package is available from apt. Install and proxy it separately if you want a local SOGo backend."
fi

systemctl restart cp || true
echo "Snappymail + SOGo plugin bridge installed on OLSPanel: $BASE_DIR"
