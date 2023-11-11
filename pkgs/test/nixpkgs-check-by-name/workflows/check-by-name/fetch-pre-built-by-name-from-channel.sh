#!/usr/bin/env bash
echo "Fetching pre-built nixpkgs-check-by-name from channel $channel at revision $rev"
# Passing --max-jobs 0 makes sure that we won't build anything
nix-build "$nixpkgs" -A tests.nixpkgs-check-by-name --max-jobs 0
