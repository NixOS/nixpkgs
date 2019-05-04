#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

exec node2nix -8 \
    --input node-packages.json \
    --output node-packages-generated.nix \
    --composition node-packages.nix \
    --node-env ./../../../development/node-packages/node-env.nix
