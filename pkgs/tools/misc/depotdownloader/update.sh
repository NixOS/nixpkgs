#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p jq curl common-updater-scripts nix coreutils

set -eou pipefail

<<<<<<< HEAD
=======
depsFile="$(realpath "$(dirname "${BASH_SOURCE[0]}")/deps.nix")"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
currentVersion="$(nix eval --raw -f . depotdownloader.version)"
latestVersion="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/SteamRE/DepotDownloader/releases?per_page=1" \
    | jq -r '.[].name' | cut -d' ' -f2)"

if [[ "$currentVersion" = "$latestVersion" ]]; then
    echo "Already up to date!"
    exit
fi

update-source-version depotdownloader "$latestVersion"
<<<<<<< HEAD
$(nix-build -A depotdownloader.fetch-deps --no-out-link)
=======
$(nix-build -A depotdownloader.fetch-deps --no-out-link) "$depsFile"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
