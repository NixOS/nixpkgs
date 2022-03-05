#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix
set -euo pipefail

if [[ "$#" -ne 1 || "$1" == -* ]]; then
    echo "Regenerates the npm dependency lock files for the prometheus package."
    echo "Usage: $0 <git release tag>"
    exit 1
fi

update() {
    RELEASE_TAG=$1
    GIT_PATH=$2
    OUTPUT_PATH=$3
    NODE_ENV=$4

    PROM_WEB_SRC="https://raw.githubusercontent.com/prometheus/prometheus/$1"
    wget "$PROM_WEB_SRC/$GIT_PATH/package.json" -O package.json
    wget "$PROM_WEB_SRC/$GIT_PATH/package-lock.json" -O package-lock.json

    node2nix \
        --lock package-lock.json \
        --development \
        --node-env $NODE_ENV \
        --no-copy-node-env

    mkdir -p $OUTPUT_PATH
    mv default.nix node-packages.nix package.json package-lock.json $OUTPUT_PATH
}

update $1 "web/ui/module/codemirror-promql" "codemirror-promql" ../../../../../development/node-packages/node-env.nix
update $1 "web/ui/react-app" "webui" ../../../../../development/node-packages/node-env.nix
