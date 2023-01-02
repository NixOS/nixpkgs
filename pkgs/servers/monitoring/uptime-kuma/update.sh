#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts nodePackages.node2nix gnused nix coreutils jq

set -euo pipefail

latestVersion="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/louislam/uptime-kuma/releases?per_page=1" | jq -r ".[0].tag_name" | sed 's/^v//')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; uptime-kuma.version or (lib.getVersion uptime-kuma)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "uptime-kuma is up-to-date: $currentVersion"
  exit 0
fi

update-source-version uptime-kuma 0 0000000000000000000000000000000000000000000000000000000000000000
update-source-version uptime-kuma "$latestVersion"

# use patched source
store_src="$(nix-build . -A uptime-kuma.src --no-out-link)"

cd "$(dirname "${BASH_SOURCE[0]}")"

node2nix \
  --nodejs-16 \
  --node-env ./node-env.nix \
  --output ./node-packages.nix \
  --lock "$store_src/package-lock.json" \
  --composition ./composition.nix


