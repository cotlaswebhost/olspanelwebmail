#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install-webmail-plugins.sh"

if [[ ! -x "$INSTALL_SCRIPT" ]]; then
  chmod +x "$INSTALL_SCRIPT"
fi

if command -v git >/dev/null 2>&1 && [[ -d "$REPO_ROOT/.git" ]]; then
  echo "Updating local repository in $REPO_ROOT"
  git -C "$REPO_ROOT" pull --ff-only
else
  echo "Git repo not detected; running local installer content only."
fi

echo "Applying latest webmail plugin files..."
exec bash "$INSTALL_SCRIPT"
