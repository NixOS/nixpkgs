#!/bin/sh -e

node2nix -i pkgs.json -c nodepkgs.nix -e ../../node-packages/node-env.nix
