#!/usr/bin/env bash

set -x
CHECK_META=$1

nix-instantiate --eval --strict --json pkgs/top-level/release-attrpaths-superset.nix -A names > release-attrpaths-superset.out

NUM_CHUNKS=$((4*$NIX_BUILD_CORES))

parallel -j $NIX_BUILD_CORES \
  nix-env -qaP --no-name --out-path -f pkgs/top-level/release-outpaths-parallel.nix --arg checkMeta "$1" --arg numChunks $NUM_CHUNKS --arg myChunk \
  -- $(seq 0 $(($NUM_CHUNKS-1))) \
| sort
