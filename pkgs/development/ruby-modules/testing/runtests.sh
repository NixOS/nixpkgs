#!/usr/bin/env bash
nix-build -E 'with import <nixpkgs> { }; callPackage ./test.nix {}' --show-trace && cat result
