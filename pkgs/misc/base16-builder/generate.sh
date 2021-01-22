#!/usr/bin/env bash

node2nix=$(nix-build ../../.. --no-out-link -A nodePackages.node2nix)

exec ${node2nix}/bin/node2nix --nodejs-10 \
     --input node-packages.json \
     --output node-packages-generated.nix \
     --supplement-input supplement.json \
     --composition node-packages.nix \
     --node-env ./../../development/node-packages/node-env.nix \
