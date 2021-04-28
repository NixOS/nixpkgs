#! /usr/bin/env nix-shell
#! nix-shell -i bash -p cargo coreutils git gnugrep jq

set -eu -o verbose

here=$PWD
version=$(cat unwrapped.nix | grep '^  version = "' | cut -d '"' -f 2)
checkout=$(mktemp -d)
git clone -b "v$version" --depth=1 https://github.com/JonathanHelianthicusDoe/shticker_book_unwritten "$checkout"
cd "$checkout"

rm -f rust-toolchain
cargo generate-lockfile
git add -f Cargo.lock
git diff HEAD -- Cargo.lock > "$here"/cargo-lock.patch

cd "$here"
rm -rf "$checkout"
