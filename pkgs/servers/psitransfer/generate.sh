#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix
set -euo pipefail

node2nix \
  --input node-packages.json \
  --output node-packages.nix \
  --composition node-composition.nix \
  --node-env ../../development/node-packages/node-env.nix \
  ;
