#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq nix-prefetch common-updater-scripts nix coreutils
# shellcheck shell=bash
set -euo pipefail

VERSION=$(curl -s https://api.github.com/repos/facebook/buck2/releases \
  | jq -r '. |
           sort_by(.created_at) | .[] |
           select ((.prerelease == true) and (.name != "latest")) |
           .name')
echo "Latest buck2 prerelease: $VERSION"

ARCHS=(
    "x86_64-linux:x86_64-unknown-linux-gnu"
    "x86_64-darwin:x86_64-apple-darwin"
    "aarch64-linux:aarch64-unknown-linux-gnu"
    "aarch64-darwin:aarch64-apple-darwin"
)

NFILE=pkgs/development/tools/build-managers/buck2/default.nix
HFILE=pkgs/development/tools/build-managers/buck2/hashes.json
rm -f "$HFILE" && touch "$HFILE"

marker="{"
for arch in "${ARCHS[@]}"; do
    IFS=: read -r arch_name arch_target <<< "$arch"
    sha256hash="$(nix-prefetch-url --type sha256 "https://github.com/facebook/buck2/releases/download/${VERSION}/buck2-${arch_target}.zst")"
    srihash="$(nix hash to-sri --type sha256 "$sha256hash")"

    echo "${marker} \"$arch_name\": \"$srihash\"" >> "$HFILE"
    marker=","
done

echo "}" >> "$HFILE"

sed -i \
  's/buck2-version\s*=\s*".*";/buck2-version = "'"$VERSION"'";/' \
  "$NFILE"

echo "Done; wrote $HFILE and updated version"
