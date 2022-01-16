#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update
set -eu -o pipefail

nix-update ripe-atlas-tools
