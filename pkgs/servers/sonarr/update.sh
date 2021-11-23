#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash

latestTag=$(curl https://api.github.com/repos/Sonarr/Sonarr/tags | jq -r '.[] | .name' | sort --version-sort | tail -1)
version="$(expr $latestTag : 'v\(.*\)')"

update-source-version sonarr "$version"
