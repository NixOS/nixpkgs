#!/usr/bin/env bash

set -eu -o pipefail

if [[ $# -lt 1 ]]; then
    echo "$0: version" >&2
    exit 1
fi

VERSION="$1"

declare -A SYSTEMS HASHES
SYSTEMS=(
    [i686-linux]=linux-ia32
    [x86_64-linux]=linux-x64
    [armv7l-linux]=linux-armv7l
    [aarch64-linux]=linux-arm64
    [x86_64-darwin]=darwin-x64
    [aarch64-darwin]=darwin-arm64
)

hashfile="$(nix-prefetch-url --print-path "https://github.com/electron/electron/releases/download/v${VERSION}/SHASUMS256.txt" | tail -n1)"
headers="$(nix-prefetch-url "https://artifacts.electronjs.org/headers/dist/v${VERSION}/node-v${VERSION}-headers.tar.gz")"

# Entry similar to the following goes in default.nix:

echo "  electron_${VERSION%%.*}-bin = mkElectron \"${VERSION}\" {"

for S in "${!SYSTEMS[@]}"; do
  hash="$(grep " *electron-v${VERSION}-${SYSTEMS[$S]}.zip$" "$hashfile"|cut -f1 -d' ' || :)"
  if [[ -n $hash ]]; then
    echo "    $S = \"$hash\";"
  fi
done

echo "    headers = \"$headers\";"

echo "  };"
