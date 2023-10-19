#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts gnused nix coreutils

set -euo pipefail

latestVersion="$(curl -s "https://api.github.com/repos/jellyfin/jellyfin/releases?per_page=1" | jq -r ".[0].tag_name" | sed 's/^v//')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; jellyfin.version or (lib.getVersion jellyfin)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "jellyfin is up-to-date: $currentVersion"
  exit 0
fi

update-source-version jellyfin "$latestVersion"

$(nix-build . -A jellyfin.fetch-deps --no-out-link)
