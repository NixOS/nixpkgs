#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch jq common-updater-scripts
# shellcheck shell=bash

set -e

info=$(nix-prefetch-git --quiet --url "https://github.com/archlinux/svntogit-packages" --rev "refs/heads/packages/xorg-server")

rev=$(jq -r '.rev' <<< "$info")
sha256=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$(jq -r '.sha256' <<< "$info")")
dir=$(jq -r '.path' <<< "$info")

newXvfbsha=$(sha256sum "$dir/trunk/xvfb-run")
oldXvfbsha=$(sha256sum "$(nix build --quiet ".#xvfb-run.src" --json --no-link | jq -r '.[].outputs.out')/trunk/xvfb-run")

if [[ "$newXvfbsha" != "$oldXvfbsha" ]]; then
    (
        cd "$(git rev-parse --show-toplevel)"
        update-source-version xvfb-run "1+g${rev:0:7}" "$sha256" --rev="$rev"
    )
fi
