#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

exec node2nix -8 -i pkg.json -c nixui.nix -e ../../../development/node-packages/node-env.nix --no-copy-node-env
