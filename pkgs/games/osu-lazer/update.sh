#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../. -i bash -p curl jq common-updater-scripts
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath ./deps.nix)"
bin_file="$(realpath ./bin.nix)"

new_version="$(curl -s "https://api.github.com/repos/ppy/osu/releases?per_page=1" | jq -r '.[0].name')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"
if [[ "$new_version" == "$old_version" ]]; then
  echo "Up to date"
  exit 0
fi

cd ../../..

if [[ "$1" != "--deps-only" ]]; then
  update-source-version osu-lazer "$new_version"
  sed -Ei.bak '/ *version = "/s/".+"/"'"$new_version"'"/' "$bin_file"
  rm "$bin_file.bak"
  for pair in \
    'aarch64-darwin osu.app.Apple.Silicon.zip' \
    'x86_64-darwin osu.app.Intel.zip' \
    'x86_64-linux osu.AppImage' \
  ; do
    set -- $pair
    nix-prefetch-url "https://github.com/ppy/osu/releases/download/$new_version/$2" | while read -r hash; do
      nix --extra-experimental-features nix-command hash to-sri --type sha256 "$hash" | while read -r hash; do
        sed -Ei.bak '/ *'"$1"' = "sha256-/s@".+"@"'"$hash"'"@' "$bin_file"
        rm "$bin_file.bak"
      done
    done
  done
fi

$(nix-build . -A osu-lazer.fetch-deps --no-out-link) "$deps_file"
