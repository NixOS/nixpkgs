#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash

set -eu -o pipefail

version=$(curl -s 'https://launchermeta.mojang.com/v1/products/launcher/6f083b80d5e6fabbc4236f81d0d8f8a350c665a9/linux.json' | jq -r '."launcher-core"[0].version.name')
update-source-version minecraft "${version}"
