#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq nix-prefetch
set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

CURRENT_VERSION=$(nix-instantiate --eval --strict --json -A tailwindcss.version . | jq -r .)
LATEST_VERSION=$(curl --fail --silent https://api.github.com/repos/tailwindlabs/tailwindcss/releases/latest | jq --raw-output .tag_name | sed 's/v//')
sed -i "s/version = \".*\"/version = \"${LATEST_VERSION}\"/" "$ROOT/default.nix"

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo "tailwindcss already at latest version $CURRENT_VERSION, exiting"
    exit 0
fi

function updatePlatform() {
    NIXPLAT=$1
    TAILWINDPLAT=$2
    echo "Updating tailwindcss for $NIXPLAT"

    URL="https://github.com/tailwindlabs/tailwindcss/releases/download/v${LATEST_VERSION}/tailwindcss-${TAILWINDPLAT}"
    HASH=$(nix hash to-sri --type sha256 "$(nix-prefetch-url --type sha256 "$URL")")

    sed -i "s,$NIXPLAT = \"sha256.*\",$NIXPLAT = \"${HASH}\"," "$ROOT/default.nix"
}

updatePlatform aarch64-darwin macos-arm64
updatePlatform aarch64-linux linux-arm64
updatePlatform armv7l-linux linux-armv7
updatePlatform x86_64-darwin macos-x64
updatePlatform x86_64-linux linux-x64
