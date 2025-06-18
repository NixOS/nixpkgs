#!/usr/bin/env bash
set -o xtrace
cd $(dirname $0)
find . -name text.nix
testfiles=$(find . -name test.nix)
nix-build -E "with import <nixpkgs> {}; callPackage testing/driver.nix { testFiles = [ $testfiles ]; }" --show-trace && cat result
