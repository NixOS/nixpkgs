#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p jq curl common-updater-scripts nix coreutils

set -eou pipefail

currentVersion="$(nix eval --raw -f . depotdownloader.version)"
latestVersion="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/SteamRE/DepotDownloader/releases?per_page=1" \
    | jq -r '.[].name' | cut -d' ' -f2)"

if [[ "$currentVersion" = "$latestVersion" ]]; then
    echo "Already up to date!"
    exit
fi

update-source-version depotdownloader "$latestVersion"
$(nix-build -A depotdownloader.fetch-deps --no-out-link)
