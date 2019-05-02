#!/usr/bin/env nix-shell
#!nix-shell -i bash -p stdenv nix-prefetch-github yarn2nix bundix coreutils jq curl nix git gawk gnused
set -ve

OWNER="tootsuite"
REPO="mastodon"

rm -f gemset.nix yarn.nix version.nix source-unpatched.nix package.json
TARGET_DIR="$PWD"
VERSION="$(curl https://api.github.com/repos/$OWNER/$REPO/releases/latest | jq -r .tag_name)"
echo \"$VERSION\" | sed 's/^"v/"/' > version.nix

nix-prefetch-github tootsuite mastodon --rev $VERSION --nix > "$TARGET_DIR/source-unpatched.nix"
SOURCE_DIR="$(nix-build -E '(import <nixpkgs> {}).callPackage ./source-patched.nix {}')"

# create gemset.nix
bundix --lockfile="$SOURCE_DIR/Gemfile.lock" --gemfile="$SOURCE_DIR/Gemfile"

# create yarn.nix
cd "$SOURCE_DIR"
yarn2nix > "$TARGET_DIR/yarn.nix"
sed "s/https___.*_//g" -i "$TARGET_DIR/yarn.nix"

# create package.json
cp "$SOURCE_DIR/package.json" "$TARGET_DIR/package.json"
