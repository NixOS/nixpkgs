#!/bin/sh -e

node2nix=$(nix-build ../../../.. --no-out-link -A nodePackages.node2nix)

${node2nix}/bin/node2nix --nodejs-10 -i pkgs.json -c nodepkgs.nix -e ../../node-packages/node-env.nix
