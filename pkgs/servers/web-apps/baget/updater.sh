#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p gnused jq common-updater-scripts nix-prefetch-github
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath ./deps.nix)"

new_version="$(curl -s "https://api.github.com/repos/loic-sharma/BaGet/releases?per_page=1" | jq -r '.[0].name' | sed 's,^v,,')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date!"
  exit 0
fi

new_rev="v$new_version"
nix-prefetch-github loic-sharma BaGet --rev "$new_rev" > repo_info
new_hash="$(jq -r ".sha256" < repo_info)"
rm repo_info

pushd ../../../..

update-source-version baget "$new_version" "$new_hash"
$(nix-build -A baget.fetch-deps --no-out-link) "$deps_file"
