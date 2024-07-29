#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch jq

set -euo pipefail
URL="https://github.com/fable-compiler/fable"
PKG="Fable"
ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/default.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find default.nix in $ROOT"
  exit 1
fi

TMP="$(mktemp -d)"
clean_up() {
    rm -rf "$TMP"
}
trap clean_up EXIT SIGINT SIGTERM
PACKAGES="$TMP/packages"
SRC_RW="$TMP/src"

mkdir -p $SRC_RW
mkdir -p $PACKAGES


VER=$(curl -s "https://api.github.com/repos/fable-compiler/fable/releases/latest" | jq -r .tag_name | grep -oP '\d+\.\d+\.\d+' )

CURRENT_VER=$(grep -oP '(?<=version = ")[^"]+' "$NIX_DRV")
if [[ "$CURRENT_VER" == "$VER" ]]; then
    echo "$PKG is already up to date: $CURRENT_VER"
    exit
fi


NUGET_URL="$(curl -f "https://api.nuget.org/v3/index.json" | jq --raw-output '.resources[] | select(."@type" == "PackageBaseAddress/3.0.0")."@id"')$PKG/$VER/$PKG.$VER.nupkg"
HASH=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url "$NUGET_URL")")

sed -i "s/version = \".*\"/version = \"$VER\"/" "$NIX_DRV"
sed -i "s#nugetHash = \"sha256-.\{44\}\"#nugetHash = \"$HASH\"#" "$NIX_DRV"
