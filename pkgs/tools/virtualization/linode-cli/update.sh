#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq yq-go
# shellcheck shell=bash

set -x -eu -o pipefail

cd $(dirname "${BASH_SOURCE[0]}")

SPEC_VERSION=$(curl -s https://www.linode.com/docs/api/openapi.yaml | yq eval '.info.version' -)

SPEC_SHA256=$(nix-prefetch-url --quiet https://raw.githubusercontent.com/linode/linode-api-docs/v${SPEC_VERSION}/openapi.yaml)

VERSION=$(curl -s ${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/linode/linode-cli/tags" \
    | jq 'map(.name)' \
    | grep '"' \
    | sed 's/[ ",(^v)]//g' \
    | grep -v -e rc -e list \
    | cut -d '"' -f4 | sort -rV | head -n 1)

SHA256=$(nix-prefetch-url --quiet --unpack https://github.com/linode/linode-cli/archive/refs/tags/${VERSION}.tar.gz)

setKV () {
    sed -i "s|$1 = \".*\"|$1 = \"${2:-}\"|" ./default.nix
}

setKV specVersion ${SPEC_VERSION}
setKV specSha256 ${SPEC_SHA256}
setKV version ${VERSION}
setKV sha256 ${SHA256}
