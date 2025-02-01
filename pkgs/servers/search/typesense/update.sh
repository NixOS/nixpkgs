#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch common-updater-scripts nix coreutils
# shellcheck shell=bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

old_version=$(jq -r ".version" sources.json || echo -n "0.0.1")
version=$(curl -s "https://api.github.com/repos/typesense/typesense/releases/latest" | jq -r ".tag_name")
version="${version#v}"

if [[ "$old_version" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

declare -A platforms=(
    [aarch64-linux]="linux-arm64"
    [aarch64-darwin]="darwin-arm64"
    [x86_64-darwin]="darwin-amd64"
    [x86_64-linux]="linux-amd64"
)

sources_tmp="$(mktemp)"
cat <<EOF > "$sources_tmp"
{
  "version": "$version",
  "platforms": {}
}
EOF

for platform in "${!platforms[@]}"; do
    arch="${platforms[$platform]}"
    url="https://dl.typesense.org/releases/${version}/typesense-server-${version}-${arch}.tar.gz"
    sha256hash="$(nix-prefetch-url --type sha256 "$url")"
    hash="$(nix hash to-sri --type sha256 "$sha256hash")"
    echo "$(jq --arg arch "$arch" \
      --arg platform "$platform" \
      --arg hash "$hash" \
      '.platforms += {($platform): {arch: $arch, hash: $hash}}' \
      "$sources_tmp")" > "$sources_tmp"
done

cp "$sources_tmp" sources.json
