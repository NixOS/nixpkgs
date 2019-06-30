#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

node2nix \
    --nodejs-10 \
    --input package.json \
    --development \
    --output node-packages-generated.nix \
    --composition node-packages.nix \
     --node-env ../../../development/node-packages/node-env.nix
