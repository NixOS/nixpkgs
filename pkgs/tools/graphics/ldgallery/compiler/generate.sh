#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cabal2nix
# shellcheck shell=bash

set -euo pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates the nix file for the ldgallery-compiler package."
  echo "Usage: $0 <git release tag>"
  exit 1
fi

echo "# generated with cabal2nix by ./generate.sh" > default.nix

cabal2nix \
  --maintainer pacien \
  --subpath compiler \
  --revision $1 \
  "https://github.com/pacien/ldgallery.git" \
  >> default.nix
