#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix nodePackages.bower2nix
set -euo pipefail

node2nix -6 \
     --input node-packages.json \
     --output node-packages-generated.nix \
     --composition node-packages.nix \
     --node-env ../../../development/node-packages/node-env.nix \

# TODO: bower2nix > bower-packages.nix
