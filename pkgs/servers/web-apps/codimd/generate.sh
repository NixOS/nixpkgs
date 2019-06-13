#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

node2nix -8 -i deps.json \
  -e ../../../development/node-packages/node-env.nix \
  --no-copy-node-env \
  -c node.nix
