#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix wget nix-prefetch-github moreutils jq prefetch-npm-deps nodejs

set -euo pipefail

TARGET_VERSION_REMOTE=$(curl -s https://api.github.com/repos/usememos/memos/releases/latest | jq -r ".tag_name")
TARGET_VERSION=${TARGET_VERSION_REMOTE#v}

if [[ "$UPDATE_NIX_OLD_VERSION" == "$TARGET_VERSION" ]]; then
  echo "memos is up-to-date: ${UPDATE_NIX_OLD_VERSION}"
  exit 0
fi

extractVendorHash() {
  original="${1?original hash missing}"
  result="$(nix-build -A memos.goModules 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo || true)"
  [ -z "$result" ] && { echo "$original"; } || { echo "$result"; }
}

replaceHash() {
  old="${1?old hash missing}"
  new="${2?new hash missing}"
  awk -v OLD="$old" -v NEW="$new" '{
    if (i=index($0, OLD)) {
      $0 = substr($0, 1, i-1) NEW substr($0, i+length(OLD));
    }
    print $0;
  }' ./pkgs/servers/memos/default.nix | sponge ./pkgs/servers/memos/default.nix
}

# change version number
sed -e "s/version =.*;/version = \"$TARGET_VERSION\";/g" \
    -i ./pkgs/servers/memos/default.nix

# update hash
SRC_HASH="$(nix-instantiate --eval -A memos.src.outputHash | tr -d '"')"
NEW_HASH="$(nix-prefetch-github usememos memos --rev v$TARGET_VERSION | jq -r .hash)"

replaceHash "$SRC_HASH" "$NEW_HASH"

GO_HASH="$(nix-instantiate --eval -A memos.vendorHash | tr -d '"')"
EMPTY_HASH="$(nix-instantiate --eval -A lib.fakeHash | tr -d '"')"
replaceHash "$GO_HASH" "$EMPTY_HASH"
replaceHash "$EMPTY_HASH" "$(extractVendorHash "$GO_HASH")"

# update src yarn lock
SRC_FILE_BASE="https://raw.githubusercontent.com/usememos/memos/v$TARGET_VERSION"

trap 'rm -rf ./pkgs/servers/memos/package.json' EXIT
pushd ./pkgs/servers/memos
wget -q "$SRC_FILE_BASE/web/package.json"
npm install --package-lock-only
NPM_HASH=$(prefetch-npm-deps ./package-lock.json)
popd

sed -i -E -e "s#npmDepsHash = \".*\"#npmDepsHash = \"$NPM_HASH\"#" ./pkgs/servers/memos/default.nix
