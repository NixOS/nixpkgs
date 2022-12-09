#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p coreutils gnused nix nix-update nodePackages.npm
set -euo pipefail

DRV_DIR="$(dirname "${BASH_SOURCE[0]}")"
DRV_DIR=$(realpath $DRV_DIR)
NIXPKGS_ROOT="$DRV_DIR/../../.."
NIXPKGS_ROOT=$(realpath $NIXPKGS_ROOT)

instantiateClean() {
    nix-instantiate --eval --strict -E "with import ./. {}; $1" | cut -d\" -f2
}
fetchNewSha() {
    set +eo pipefail
    nix-build -A "$1" 2>&1 >/dev/null | grep "got:" | cut -d':' -f2 | sed 's| ||g'
    set -eo pipefail
}
replace() {
    sed -i "s@$1@$2@g" "$3"
}

grab_version() {
    instantiateClean "authelia.version"
}

OLD_VERSION=$(instantiateClean "authelia.version")

nix-update authelia

NEW_VERSION=$(instantiateClean "authelia.version")
if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
    echo "already up to date"
    exit
fi

# build package-lock.json since authelia uses pnpm
# since they hard pin dependencies in package.json we can be pretty confident that versions will match
WEB_DIR=$(mktemp -d)
clean_up() {
  rm -rf "$WEB_DIR"
}
trap clean_up EXIT

OLD_PWD=$PWD
cd $WEB_DIR
OUT=$(nix-build -E "with import $NIXPKGS_ROOT {}; authelia.src" --no-out-link)
cp -r $OUT/web/package.json .
npm install --package-lock-only --legacy-peer-deps --ignore-scripts
mv package-lock.json "$DRV_DIR/"

cd $OLD_PWD
OLD_HASH="$(instantiateClean authelia.web.npmDepsHash)"
echo "Old hash $OLD_HASH"
TMP_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
replace "$OLD_HASH" "$TMP_HASH" "$DRV_DIR/default.nix"
NEW_HASH="$(fetchNewSha authelia.web)"
echo "New hash $NEW_HASH"
replace "$TMP_HASH" "$NEW_HASH" "$DRV_DIR/default.nix"
clean_up
