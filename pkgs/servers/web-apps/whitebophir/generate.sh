#!/usr/bin/env bash
set -euo pipefail

node2nix=$(nix-build ../../../.. --no-out-link -A nodePackages.node2nix)

${node2nix}/bin/node2nix \
     --input node-packages.json \
     --output node-packages-generated.nix \
     --composition node-packages.nix \
     --node-env ../../../development/node-packages/node-env.nix
