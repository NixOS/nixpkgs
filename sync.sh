#!/usr/bin/env bash

local_root=~/.config/nix/
nixpkgs_root="$(dirname "$0")"

cp "$local_root"/modules/pihole-ftl* "$nixpkgs_root"/nixos/modules/services/networking/
cp "$local_root"/modules/pihole-web* "$nixpkgs_root"/nixos/modules/services/web-apps/

cp -r "$local_root"/pkgs/pihole* "$nixpkgs_root"/pkgs/by-name/pi/
cp -r "$local_root"/modules/pihole-web* "$nixpkgs_root"/nixos/modules/services/web-apps/
