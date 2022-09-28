#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodePackages.node2nix
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

node2nix \
    --nodejs-14 \
    -i plugins.json \
    -o plugins-packages.nix \
    -c composition.nix \
    -e ../../../development/node-packages/node-env.nix
