#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils moreutils curl jq nix-prefetch-git cargo gnugrep gawk nix
# shellcheck shell=bash

# You must run it from the root directory of a nixpkgs repo checkout

set -euo pipefail

versionJson="$(realpath "./pkgs/os-specific/linux/scx/version.json")"
nixFolder="$(dirname "$versionJson")"

localVer=$(jq -r .scx.version <$versionJson)
latestVer=$(curl -s https://api.github.com/repos/sched-ext/scx/releases/latest | jq -r .tag_name | sed 's/v//g')

if [ "$localVer" == "$latestVer" ]; then
  exit 0
fi

latestHash=$(nix-prefetch-git https://github.com/sched-ext/scx.git --rev refs/tags/v$latestVer --quiet | jq -r .hash)

jq \
  --arg latestVer "$latestVer" --arg latestHash "$latestHash" \
  ".scx.version = \$latestVer | .scx.hash = \$latestHash" \
  "$versionJson" | sponge $versionJson

echo "scx: $localVer -> $latestVer"

echo "Updating cargoHash. This may take a while..."
cargoHash=$((nix-build --attr scx.rustscheds 2>&1 || true) | awk '/got/{print $2}')

if [ -z "$cargoHash" ]; then
  echo "Failed to get cargoHash, please update it manually"
  exit 0
fi

jq \
  --arg cargoHash "$cargoHash" \
  ".scx.cargoHash = \$cargoHash" \
  "$versionJson" | sponge $versionJson
