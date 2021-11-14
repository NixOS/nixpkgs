#!/usr/bin/env nix-shell
#! nix-shell -i bash -I nixpkgs=../../../.. -p nodePackages.node2nix nix
# shellcheck shell=bash

# This script is meant to be run in the current directory

cryptpadSrc=$(nix eval '(import ../../../.. {}).cryptpad.src' --raw)
echo "cryptpad src: $cryptpadSrc"

nix-shell -I nixpkgs=../../../.. -p '(nodePackages.override { nodejs = nodejs-10_x; }).bower2nix' --run "bower2nix $cryptpadSrc/bower.json bower-packages.nix"


set -euo pipefail

node2nix --nodejs-12 \
     --input node-packages.json \
     --output node-packages-generated.nix \
     --composition node-packages.nix \
     --node-env ../../../development/node-packages/node-env.nix
