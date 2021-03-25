#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

# Download package.json and package-lock.json from the v1.4.0 release
curl https://raw.githubusercontent.com/matrix-org/matrix-appservice-slack/9462a75715ea9afba23b757ec90554f10f457a96/package.json -o package.json
curl https://raw.githubusercontent.com/matrix-org/matrix-appservice-slack/9462a75715ea9afba23b757ec90554f10f457a96/package-lock.json -o package-lock.json

node2nix \
  --nodejs-12 \
  --node-env ../../../development/node-packages/node-env.nix \
  --development \
  --input package.json \
  --lock package-lock.json \
  --output node-packages.nix \
  --composition node-composition.nix \

rm -f package.json package-lock.json
