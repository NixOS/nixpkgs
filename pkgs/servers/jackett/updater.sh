#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

new_version="$(curl -s "https://api.github.com/repos/jackett/jackett/releases?per_page=1" | jq -r '.[0].name')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date!"
  exit 0
fi

cd ../../..
update-source-version jackett "${new_version//v}"
$(nix-build -A jackett.fetch-deps --no-out-link)
