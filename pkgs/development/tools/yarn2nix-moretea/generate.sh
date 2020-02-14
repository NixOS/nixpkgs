#!/usr/bin/env bash

###
### This script runs 'nix-build' with ./fetch-source.nix and copies a subset
### of the resulting store path into the current working directory.
###
### To disable running chmod, you may set the environment
### variable "FIX_RIGHTS" to "no".
###

set -euo pipefail

# 'nix-build' command
NIX_BUILD_BIN="${NIX_BUILD_BIN:-"/usr/bin/env nix-build"}"

# where to place the yarn2nix source
TARGET_DIR="${TARGET_DIR:-"./yarn2nix"}"

# whether to run 'chmod -R u=rwX,g=rX,o-rwx' on copied files in $TARGET_DIR
FIX_RIGHTS="${FIX_RIGHTS:-"yes"}"

fetch_git_source() {
  [[ -f ./fetch-source.nix ]] && ret="$($NIX_BUILD_BIN --no-out-link ./fetch-source.nix)" && ec="$?" || ec="$?"
  if [[ "$ec" == "0" ]]; then
    echo "$ret"
  else
    printf "error: failed at 'fetch_git_source()' with '%s'" "$ret"
  fi
}

result="$(fetch_git_source)"
if [[ "$result" == "/nix/store"* ]]; then
  mkdir -p "$TARGET_DIR"
  cp -Rv \
    "${result}/"{bin,internal,lib,nix,default.nix,package.json,yarn.nix,yarn.lock,LICENSE.txt} \
    "$TARGET_DIR"
  [[ "$FIX_RIGHTS" = "yes" ]] \
    && chmod -v "u=rwX,g=rX,o-rwx" -R \
    "$TARGET_DIR/"{bin,internal,lib,nix,default.nix,package.json,yarn.nix,yarn.lock,LICENSE.txt}
fi
