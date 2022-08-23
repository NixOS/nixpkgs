#!/usr/bin/env nix-shell
#! nix-shell -i bash -p gomod2nix
set -euo pipefail

nixpkgs_dir="$1"

# Builder sources directory
builder_dir=$(readlink -f "$nixpkgs_dir/pkgs/build-support/go/gomod2nix")

# Regenerate gomod2nix package
gomod2nix generate "github.com/nix-community/gomod2nix"

# Get gomod2nix sources to copy builder expressions
store_path=$(nix-build "$nixpkgs_dir" --no-out-link -A gomod2nix.src)

# Clear out any existing builder expressions
rm -rf "$builder_dir"
cp -r --no-preserve=mode,ownership "$store_path/builder" "$builder_dir"

# Test the generated build
nix-build "$nixpkgs_dir" --no-out-link -A gomod2nix
