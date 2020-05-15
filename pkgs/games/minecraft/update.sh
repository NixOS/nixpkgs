#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnugrep common-updater-scripts

set -eu -o pipefail

version=$(curl -s 'https://aur.archlinux.org/rpc/?v=5&type=info&arg[]=minecraft-launcher' | jq '.results[0].Version' | grep -Po '[.\d]*(?=-)')
update-source-version minecraft "$version"
