#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts vgo2nix
# shellcheck shell=bash

set -eu -o pipefail

basedir="$(git rev-parse --show-toplevel)"
version="$(curl -sL https://build.wireguard.com/distros.txt | sed -n 's/^upstream\tgo\t\([^\t]\+\)\t.*/\1/p')"
update-source-version wireguard-go "$version"

vgo2nix -dir $(nix-build -A wireguard-go.src) -outfile "$basedir/pkgs/tools/networking/wireguard-go/deps.nix"

if [[ -f "$basedir/wireguard-go.log" ]];then
    rm "$basedir/wireguard-go.log"
fi
