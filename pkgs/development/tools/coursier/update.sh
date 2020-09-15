#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [ ! -f "$ROOT/default.nix" ]; then
  echo "ERROR: cannot find default.nix in $ROOT"
  exit 1
fi

COURSIER_VER=$(git ls-remote --tags --refs --sort=version:refname https://github.com/coursier/coursier | awk -F"/v" '{ print $NF }' | tail -1)
sed -i "s/version = \".*\"/version = \"${COURSIER_VER}\"/" "$ROOT/default.nix"

COURSIER_ZSH_URL="https://raw.githubusercontent.com/coursier/coursier/v${COURSIER_VER}/modules/cli/src/main/resources/completions/zsh"
COURSIER_ZSH_SHA256=$(nix-prefetch-url ${COURSIER_ZSH_URL})
sed -i "6s/sha256 = \".*\"/sha256 = \"${COURSIER_ZSH_SHA256}\"/" "$ROOT/default.nix"

COURSIER_URL="https://github.com/coursier/coursier/releases/download/v${COURSIER_VER}/coursier"
COURSIER_SHA256=$(nix-prefetch-url ${COURSIER_URL})
sed -i "15s/sha256 = \".*\"/sha256 = \"${COURSIER_SHA256}\"/" "$ROOT/default.nix"
