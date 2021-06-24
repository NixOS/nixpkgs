#!/bin/sh

# This updates cargo-lock.patch for the b3sum version listed in default.nix.

set -eu -o verbose

here=$PWD
version=$(cat default.nix | grep '^  version = "' | cut -d '"' -f 2)
checkout=$(mktemp -d)
git clone -b "$version" --depth=1 https://github.com/BLAKE3-team/BLAKE3 "$checkout"
cd "$checkout"

(cd b3sum && cargo generate-lockfile)
mv b3sum/Cargo.lock ./
git add -f Cargo.lock
git diff HEAD -- Cargo.lock > "$here"/cargo-lock.patch

cd "$here"
rm -rf "$checkout"
