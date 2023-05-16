#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../. -i bash -p curl jq common-updater-scripts
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

<<<<<<< HEAD
=======
deps_file="$(realpath "./deps.nix")"

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
new_version="$(curl -s "https://api.github.com/repos/ppy/osu/releases?per_page=1" | jq -r '.[0].name')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"
if [[ "$new_version" == "$old_version" ]]; then
    echo "Up to date"
    exit 0
fi

cd ../../..

if [[ "$1" != "--deps-only" ]]; then
    update-source-version osu-lazer "$new_version"
fi

<<<<<<< HEAD
$(nix-build . -A osu-lazer.fetch-deps --no-out-link)
=======
$(nix-build . -A osu-lazer.fetch-deps --no-out-link) "$deps_file"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
