#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yq ripgrep common-updater-scripts dart

set -xeu -o pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"
cd "$PACKAGE_DIR/.."
while ! test -f flake.nix; do cd .. ; done
NIXPKGS_DIR="$PWD"

version="$(
  list-git-tags --url=https://github.com/google/protobuf.dart \
  | rg '^protobuf-v(.*)' -r '$1' \
  | sort --version-sort \
  | tail -n1
)"

cd "$NIXPKGS_DIR"
update-source-version protoc-gen-dart "$version"

TMPDIR="$(mktemp -d)"
cd "$TMPDIR"

src="$(nix-build --no-link "$NIXPKGS_DIR" -A protoc-gen-dart.src)/protoc_plugin"
cp $src/pubspec.* .

if ! test -f pubspec.lock; then
  dart pub update
fi

yq . pubspec.lock > "$PACKAGE_DIR/pubspec.lock.json"

rm -rf "$TMPDIR"
