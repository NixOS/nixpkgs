#!/usr/bin/env nix-shell
#! nix-shell -i bash -p node2nix

MONGOSH_ROOT="$(
    cd "$(dirname "$0")"
    pwd
)"
pushd $MONGOSH_ROOT 1>/dev/null

rm -rf gen && mkdir -p gen

node2nix \
    --no-copy-node-env \
    --node-env ../../node-packages/node-env.nix \
    --input packages.json \
    --output gen/packages.nix \
    --composition gen/composition.nix \
    --strip-optional-dependencies \
    --nodejs-14

popd 1>/dev/null
