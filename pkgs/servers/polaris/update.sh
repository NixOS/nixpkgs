#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq nix coreutils

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"/../../..

# update github tag and hash

latestVersion="$(curl -s "https://api.github.com/repos/agersant/polaris/releases?per_page=1" | jq -r ".[0].tag_name")"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; polaris.version or (lib.getVersion polaris)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "polaris is up-to-date: $currentVersion"
  exit 0
fi

update-source-version polaris "$latestVersion"
