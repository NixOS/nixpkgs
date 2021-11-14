#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix
# shellcheck shell=bash

node2nix --nodejs-10 -i deps.json \
  --no-copy-node-env \
  -e ../../../development/node-packages/node-env.nix -c node.nix
