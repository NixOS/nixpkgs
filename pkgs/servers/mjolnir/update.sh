#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts nodePackages.node2nix gnused nix coreutils jq
# shellcheck shell=bash

set -euo pipefail

latestVersion="$(curl -s "https://api.github.com/repos/matrix-org/mjolnir/releases?per_page=1" | jq -r ".[0].tag_name" | sed 's/^v//')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; mjolnir.version or (lib.getVersion mjolnir)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "mjolnir is up-to-date: $currentVersion"
  exit 0
fi

update-source-version mjolnir 0 0000000000000000000000000000000000000000000000000000000000000000
update-source-version mjolnir "$latestVersion"

# use patched source
store_src="$(nix-build . -A mjolnir.src --no-out-link)"

cd "$(dirname "${BASH_SOURCE[0]}")"

node2nix \
  --nodejs-12 \
  --development \
  --node-env ./node-env.nix \
  --output ./node-deps.nix \
  --input "$store_src/package.json" \
  --composition ./node-composition.nix
