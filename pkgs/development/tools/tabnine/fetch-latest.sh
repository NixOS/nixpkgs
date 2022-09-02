#!/usr/bin/env bash

set -euo pipefail

function prefetch-sri() {
    nix-prefetch-url "$1" 2>/dev/null | xargs nix hash to-sri --type sha256
}

declare -a PLATFORMS=(
    x86_64-unknown-linux-musl
    x86_64-apple-darwin
    aarch64-apple-darwin
)

LATEST="$(curl -sS https://update.tabnine.com/bundles/version)"

cat <<-EOF
version = "${LATEST}";
EOF

for platform in "${PLATFORMS[@]}"; do
    url="https://update.tabnine.com/bundles/${LATEST}/${platform}/TabNine.zip"
    sha="$(prefetch-sri "$url")"
    cat <<-EOF
name = "${platform}";
hash = "${sha}";

EOF
done
