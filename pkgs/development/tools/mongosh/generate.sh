#!/usr/bin/env nix-shell
#! nix-shell -i bash -p node2nix

cd "$(dirname "$0")"

node2nix \
    --no-copy-node-env \
    --node-env ../../node-packages/node-env.nix \
    --input packages.json \
    --output packages.nix \
    --composition composition.nix \
    --strip-optional-dependencies \
    --nodejs-16
