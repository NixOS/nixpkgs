#!/bin/sh -e

node2nix -6 -i pkgs.json -c nodepkgs.nix -e ../../node-packages/node-env.nix
