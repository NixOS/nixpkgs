#!/bin/sh -e

node2nix --nodejs-10 -i pkgs.json -c nodepkgs.nix -e ../../node-packages/node-env.nix
