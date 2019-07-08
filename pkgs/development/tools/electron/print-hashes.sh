#!/usr/bin/env bash

set -eu -o pipefail

if [[ $# -lt 1 ]]; then
    echo "$0: version" >&2
    exit 1
fi


VERSION=$1

declare -A SYSTEMS HASHES
SYSTEMS=(
    [i686-linux]=linux-ia32
    [x86_64-linux]=linux-x64
    [armv7l-linux]=linux-armv7l
    [aarch64-linux]=linux-arm64
    [x86_64-darwin]=darwin-x64
)

for S in "${!SYSTEMS[@]}"; do
  HASHES["$S"]=$(nix-prefetch-url "https://github.com/electron/electron/releases/download/v${VERSION}/electron-v${VERSION}-${SYSTEMS[$S]}.zip")
done

for S in "${!HASHES[@]}"; do
    echo "$S"
    echo "sha256 = \"${HASHES[$S]}\";"
done
