#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

<<<<<<< HEAD
=======
deps_file="$(realpath "./deps.nix")"

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
new_version="$(curl -s "https://api.github.com/repos/space-wizards/SS14.Launcher/releases?per_page=1" | jq -r '.[0].tag_name' | sed 's/v//')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./space-station-14-launcher.nix)"

if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date!"
  exit 0
fi

cd ../../..
update-source-version space-station-14-launcher.unwrapped "$new_version"
<<<<<<< HEAD
$(nix-build -A space-station-14-launcher.fetch-deps --no-out-link)
=======
$(nix-build -A space-station-14-launcher.fetch-deps --no-out-link) "$deps_file"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
