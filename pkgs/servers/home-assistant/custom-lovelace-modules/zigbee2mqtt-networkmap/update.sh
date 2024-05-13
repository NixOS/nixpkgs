#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

set -xe

dirname="$(dirname "$0")"

# nix-update picks the wrong file `pkgs/development/tools/yarn2nix-moretea/yarn2nix/default.nix`
nix-update --override-filename "$dirname/default.nix" home-assistant-custom-lovelace-modules.zigbee2mqtt-networkmap
