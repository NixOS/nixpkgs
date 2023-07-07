#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts nodePackages.node2nix curl jq gnused nix coreutils

set -euo pipefail

pushd .
cd "$(dirname "${BASH_SOURCE[0]}")"/../../..

latestVersion="$(curl -s "https://api.github.com/repos/agersant/polaris-web/releases?per_page=1" | jq -r ".[0].tag_name")"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; polaris-web.version or (lib.getVersion polaris-web)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "polaris-web is up-to-date: $currentVersion"
  exit 0
fi

update-source-version polaris-web "$latestVersion"

store_src="$(nix-build . -A polaris-web.src --no-out-link)"

popd
cd "$(dirname "${BASH_SOURCE[0]}")"

node2nix \
  --nodejs-12 \
  --development \
  --node-env ../../development/node-packages/node-env.nix \
  --input "$store_src"/package.json \
  --lock "$store_src"/package-lock.json \
  --output ./node-packages.nix \
  --composition ./node-composition.nix
