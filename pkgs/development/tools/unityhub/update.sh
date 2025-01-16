#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts
# set -euo pipefail

new_version="$(curl https://hub-dist.unity3d.com/artifactory/hub-debian-prod-local/dists/stable/main/binary-amd64/Packages --silent | sed -nE "s/^Version: ([0-9]+\.[0-9]+\.[0-9]+)$/\1/p" | sort -V | tail -n 1)"
old_version="$(sed -nE 's/^\s*version = "([0-9]+\.[0-9]+\.[0-9]+)";$/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
    echo "Up to date"
    exit 0
fi

update-source-version unityhub "$new_version"
