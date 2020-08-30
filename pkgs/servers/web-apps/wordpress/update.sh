#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts jq

set -eu -o pipefail

version=$(curl --globoff "https://api.wordpress.org/core/version-check/1.7/" | jq -r '.offers[0].version')
update-source-version wordpress $version
