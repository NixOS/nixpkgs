#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../.. -i bash -p nodePackages.node2nix

# TODO: merge with other node packages in nixpkgs/pkgs/development/node-packages once
# * support for npm projects in sub-directories is added to node2nix:
#   https://github.com/svanderburg/node2nix/issues/177
# * we find a way to enable development dependencies for some of the packages

set -euo pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates the node composition and package nix files for the ldgallery-viewer package."
  echo "Usage: $0 <git release tag>"
  exit 1
fi

wget https://github.com/pacien/ldgallery/raw/$1/viewer/package.json
wget https://github.com/pacien/ldgallery/raw/$1/viewer/package-lock.json

# Development dependencies are required for this Vue application to build
node2nix \
  --node-env ../../../../development/node-packages/node-env.nix \
  --development \
  --input ./package.json \
  --lock ./package-lock.json \
  --output node-packages.nix \
  --composition node-composition.nix

rm package.json package-lock.json

# Temporary quickfix to accomodate for the util-linux package rename.
# See https://github.com/svanderburg/node2nix/issues/213
git restore :/pkgs/development/node-packages/node-env.nix
sed -i 's/utillinux/util-linux/g' node-composition.nix
