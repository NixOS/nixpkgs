#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl.bin git.out nix jq.out nodePackages.bower2nix
# shellcheck shell=bash

set -euo pipefail
IFS=$'\n\t'

# set -x

REPO=sensu/uchiwa
VERSION=0.0.1
SHA="1111111111111111111111111111111111111111111111111111"
DIR=$(pwd)

write_src() {
  cat <<_EOF > $DIR/src.nix
{
    version = "${VERSION}";
    sha256  = "${SHA}";
}
_EOF
}

LATEST_VERSION=$(curl https://api.github.com/repos/${REPO}/tags -s | jq '.[0]' -r | jq .name -r)
echo "Latest version: ${LATEST_VERSION}"

VERSION=${1:-${LATEST_VERSION}}
echo "Updating to: ${VERSION}"

TOP=$(git rev-parse --show-toplevel)

cd $(dirname $0)

write_src
pushd $TOP >/dev/null
SHA=$(nix-prefetch-url -A uchiwa.src)
popd >/dev/null
write_src

curl https://raw.githubusercontent.com/${REPO}/${VERSION}/bower.json -s > bower.json
rm -f bower-packages.nix
bower2nix bower.json $DIR/bower-packages.nix
rm -f bower.json
