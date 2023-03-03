#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts nodePackages.node2nix gnused nix coreutils jq

set -euo pipefail

latestVersion="$(curl -s "https://api.github.com/repos/toptal/haste-server/commits?per_page=1" | jq -r ".[0].sha")"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; haste-server.version or (lib.getVersion haste-server)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "haste-server is up-to-date: $currentVersion"
  exit 0
fi

update-source-version haste-server 0 sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
update-source-version haste-server "$latestVersion"

# use patched source
store_src="$(nix-build . -A haste-server.src --no-out-link)"

cd "$(dirname "${BASH_SOURCE[0]}")"

node2nix \
  --nodejs-14 \
  --development \
  --node-env ./node-env.nix \
  --output ./node-deps.nix \
  --input "$store_src/package.json" \
  --composition ./node-composition.nix
