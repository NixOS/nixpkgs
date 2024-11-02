#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

# XXX: --development is given here because we need access to gulp in order to build OnlyKey.
exec node2nix --nodejs-18 --development -i package.json -c onlykey.nix -e ../../../development/node-packages/node-env.nix --no-copy-node-env
