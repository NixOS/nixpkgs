#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

<<<<<<< HEAD
=======
deps_file="$(realpath "./deps.nix")"

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
new_version="$(curl -s "https://api.github.com/repos/EventStore/EventStore/releases/latest" | jq -r '.name')"
new_version="${new_version#oss-v}"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date!"
  exit 0
fi

cd ../../../..
update-source-version eventstore "${new_version//v}"

<<<<<<< HEAD
$(nix-build -A eventstore.fetch-deps --no-out-link)
=======
$(nix-build -A eventstore.fetch-deps --no-out-link) "$deps_file"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
