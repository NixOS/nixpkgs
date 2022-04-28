#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

exec node2nix --nodejs-10 -i pkg.json -c nixui.nix -e /dev/null --no-copy-node-env
