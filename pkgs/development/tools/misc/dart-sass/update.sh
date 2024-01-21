#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yq ripgrep common-updater-scripts dart

set -xeu -o pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"
cd "$PACKAGE_DIR/.."
while ! test -f default.nix; do cd .. ; done
NIXPKGS_DIR="$PWD"

dart_sass_version="$(
  list-git-tags --url=https://github.com/sass/dart-sass \
  | rg '^\d' \
  | sort --version-sort \
  | tail -n1
)"

embedded_protocol_version="$(
  list-git-tags --url=https://github.com/sass/sass \
  | rg '^embedded-protocol-(.*)' -r '$1' \
  | sort --version-sort \
  | tail -n1
)"

cd "$NIXPKGS_DIR"
update-source-version dart-sass "$dart_sass_version"
update-source-version dart-sass "$embedded_protocol_version" \
  --version-key=embedded-protocol-version \
  --source-key=embedded-protocol

TMPDIR="$(mktemp -d)"
cd "$TMPDIR"

src="$(nix-build --no-link "$NIXPKGS_DIR" -A dart-sass.src)"
cp $src/pubspec.* .

# Maybe one day upstream will ship a pubspec.lock,
# until then we must generate a fresh one
if ! test -f pubspec.lock; then
  dart pub update
fi

yq . pubspec.lock > "$PACKAGE_DIR/pubspec.lock.json"

rm -rf "$TMPDIR"
