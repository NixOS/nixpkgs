#!/usr/bin/env bash
nix-shell -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' -A make-deps --run 'eval "$makeDeps"'

