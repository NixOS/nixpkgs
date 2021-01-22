#!/usr/bin/env bash

node2nix=$(nix-build ../../../.. --no-out-link -A nodePackages.node2nix)

exec ${node2nix}/bin/node2nix --nodejs-10 -i pkg.json -c nixui.nix -e ../../../development/node-packages/node-env.nix --no-copy-node-env
