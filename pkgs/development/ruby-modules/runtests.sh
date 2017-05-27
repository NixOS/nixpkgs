#!/usr/bin/env bash
set -o xtrace
pwd
find . -name text.nix
testfiles=$(find . -name test.nix)
nix-build -E "with import <nixpkgs> {}; callPackage testing/driver.nix { testFiles = [ $testfiles ]; }" --show-trace && cat result
