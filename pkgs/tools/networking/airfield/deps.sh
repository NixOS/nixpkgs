#!/usr/bin/env bash

node2nix=$(nix-build ../../../.. --no-out-link -A nodePackages.node2nix)

${node2nix}/bin/node2nix --nodejs-10 -i deps.json \
  --no-copy-node-env \
  -e ../../../development/node-packages/node-env.nix -c node.nix
