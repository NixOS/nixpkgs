#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update

set -euo pipefail

PACKAGE_FILE="./pkgs/os-specific/linux/rtl8188eus-aircrack/default.nix"

if [[ ! -f "$PACKAGE_FILE" ]]; then
  echo "Error: Expected default.nix"
  exit 1
fi

date="$(
  curl -fsSL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    "https://api.github.com/repos/gglluukk/rtl8188eus/commits/HEAD" \
    | jq -er '.commit.committer.date[:10]'
)"

nix-update linuxPackages.rtl8188eus-aircrack --version=branch && sed -i -E \
    "/^[[:space:]]*version = /c\  version = \"\${kernel.version}-unstable-$date\";" \
    "$PACKAGE_FILE"
