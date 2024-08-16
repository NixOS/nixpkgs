#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts
set -eo pipefail

new_version="$(curl -s  "https://api.github.com/repos/pqrs-org/Karabiner-Elements/releases/latest" | jq -r '.tag_name | ltrimstr("v")')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date!"
  exit 0
fi

update-source-version karabiner-elements "${new_version}"
