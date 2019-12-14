#!/bin/sh

# This updates cargo-lock.patch for the cargo-outdated version listed in default.nix.

set -eu -o verbose

here=$PWD
version=$(cat default.nix | grep '^  version = "' | cut -d '"' -f 2)
checkout=$(mktemp -d)
git clone -b "v$version" --depth=1 https://github.com/kbknapp/cargo-outdated "$checkout"
cd "$checkout"

cargo generate-lockfile
git add -f Cargo.lock
git diff HEAD -- Cargo.lock > "$here"/cargo-lock.patch

cd "$here"
rm -rf "$checkout"
