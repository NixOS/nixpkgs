#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodePackages_latest.node2nix

set -euo pipefail

dirname="$(dirname "$0")"

cd $dirname
# --nodejs-12 is picked since we took node2nix from nodePackages_latest
node2nix \
     --input node-packages.json \
     --output node-packages-generated.nix \
     --supplement-input supplement.json \
     --composition composition.nix \
     --node-env node-env.nix

# Fix EditorConfig tests failure such as https://github.com/NixOS/nixpkgs/runs/1090520752
echo "" >> supplement.nix
echo "" >> composition.nix
echo "" >> node-packages-generated.nix

# Should be the root of nixpkgs
cd ../../../..

nix-build -A balena-cli
