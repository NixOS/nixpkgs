#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../ -i bash -p wget yarn2nix
# shellcheck shell=bash

set -euo pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates the Yarn dependency lock files for the matrix-appservice-discord package."
  echo "Usage: $0 <git release tag>"
  exit 1
fi

SRC_REPO="https://raw.githubusercontent.com/Half-Shot/matrix-appservice-discord/$1"

wget "$SRC_REPO/package.json" -O package.json
wget "$SRC_REPO/yarn.lock" -O yarn.lock
yarn2nix --lockfile=yarn.lock > yarn-dependencies.nix
rm yarn.lock
