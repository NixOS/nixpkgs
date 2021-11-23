#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix
# shellcheck shell=bash

# No official release
rev=c17384a6a12a42a528e0b1259f8073e8db89b8f4
u=https://raw.githubusercontent.com/matrix-discord/mx-puppet-discord/$rev
# Download package.json and package-lock.json
curl -O $u/package.json
curl -O $u/package-lock.json

node2nix \
  --nodejs-12 \
  --node-env ../../development/node-packages/node-env.nix \
  --input package.json \
  --lock package-lock.json \
  --output node-packages.nix \
  --composition node-composition.nix

sed -i 's|<nixpkgs>|../../..|' node-composition.nix

rm -f package.json package-lock.json
