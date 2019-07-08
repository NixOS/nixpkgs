#!/bin/sh -e

node2nix -8 -i pkgs.json -c nodepkgs.nix -e ../../node-packages/node-env.nix
