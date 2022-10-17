#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts nodePackages.node2nix gnused nix coreutils jq

set -euo pipefail

latestVersion="$(curl -s "https://api.github.com/repos/jellyfin/jellyfin-web/releases?per_page=1" | jq -r ".[0].tag_name" | sed 's/^v//')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; jellyfin-web.version or (lib.getVersion jellyfin-web)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "jellyfin-web is up-to-date: $currentVersion"
  exit 0
fi

update-source-version jellyfin-web 0 0000000000000000000000000000000000000000000000000000000000000000
update-source-version jellyfin-web "$latestVersion"

# use patched source
store_src="$(nix-build . -A jellyfin-web.src --no-out-link)"

cd "$(dirname "${BASH_SOURCE[0]}")"

node2nix \
  --nodejs-14 \
  --development \
  --node-env ../../development/node-packages/node-env.nix \
  --output ./node-deps.nix \
  --input "$store_src/package.json" \
  --lock "$store_src/package-lock.json" \
  --composition ./node-composition.nix
