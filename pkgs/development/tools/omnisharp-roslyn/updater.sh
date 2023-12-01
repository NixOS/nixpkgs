#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

new_version="$(curl -s "https://api.github.com/repos/OmniSharp/omnisharp-roslyn/releases?per_page=1" | jq -r '.[0].name')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date!"
  exit 0
fi

cd ../../../..
update-source-version omnisharp-roslyn "${new_version//v}"

$(nix-build -A omnisharp-roslyn.fetch-deps --no-out-link)
