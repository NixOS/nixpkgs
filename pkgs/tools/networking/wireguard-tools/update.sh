#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts
# shellcheck shell=bash

set -eu -o pipefail

version="$(curl -sL https://build.wireguard.com/distros.txt | sed -n 's/^upstream\tkmodtools\t\([^\t]\+\)\t.*/\1/p')"
update-source-version wireguard-tools "$version"
