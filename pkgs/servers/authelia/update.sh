#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p coreutils gnused curl nix jq nodePackages.npm
set -euo pipefail

DRV_DIR="$(dirname "${BASH_SOURCE[0]}")"
DRV_DIR=$(realpath "$DRV_DIR")
NIXPKGS_ROOT="$DRV_DIR/../../.."
NIXPKGS_ROOT=$(realpath "$NIXPKGS_ROOT")

instantiateClean() {
    nix-instantiate --eval --strict -E "with import ./. {}; $1" | cut -d\" -f2
}
fetchNewHash() {
    set +eo pipefail
    HASH="$(nix-build -A "$1" 2>&1 >/dev/null | grep "got:" | cut -d':' -f2 | sed 's| ||g')"
    set -eo pipefail
    if [ -z "$HASH" ]; then
      echo "Could not generate hash" >&2
      exit 1
    else
      echo "$HASH"
    fi
}
replace() {
    sed -i "s@$1@$2@g" "$3"
}

# provide a github token so you don't get rate limited
# if you use gh cli you can use:
#     `export GITHUB_TOKEN="$(cat ~/.config/gh/config.yml | yq '.hosts."github.com".oauth_token' -r)"`
# or just set your token by hand:
#     `read -s -p "Enter your token: " GITHUB_TOKEN; export GITHUB_TOKEN`
#     (we use read so it doesn't show in our shell history and in secret mode so the token you paste isn't visible)
if [ -z "${GITHUB_TOKEN:-}" ]; then
    echo "no GITHUB_TOKEN provided - you could meet API request limiting" >&2
fi

OLD_VERSION=$(instantiateClean "authelia.version")

LATEST_TAG=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} --silent https://api.github.com/repos/authelia/authelia/releases/latest | jq -r '.tag_name')
NEW_VERSION=$(echo ${LATEST_TAG} | sed 's/^v//')

if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
    echo "already up to date"
    exit
fi

TMP_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
echo "New version $NEW_VERSION"
replace "$OLD_VERSION" "$NEW_VERSION" "$DRV_DIR/sources.nix"
OLD_SRC_HASH="$(instantiateClean authelia.src.outputHash)"
echo "Old src hash $OLD_SRC_HASH"
replace "$OLD_SRC_HASH" "$TMP_HASH" "$DRV_DIR/sources.nix"
NEW_SRC_HASH="$(fetchNewHash authelia.src)"
echo "New src hash $NEW_SRC_HASH"
replace "$TMP_HASH" "$NEW_SRC_HASH" "$DRV_DIR/sources.nix"

OLD_PNPM_DEPS_HASH="$(instantiateClean authelia.web.pnpmDeps.outputHash)"
echo "Old pnpm deps hash $OLD_PNPM_DEPS_HASH"
replace "$OLD_PNPM_DEPS_HASH" "$TMP_HASH" "$DRV_DIR/sources.nix"
NEW_PNPM_DEPS_HASH="$(fetchNewHash authelia.web)"
echo "New pnpm deps hash $NEW_PNPM_DEPS_HASH"
replace "$TMP_HASH" "$NEW_PNPM_DEPS_HASH" "$DRV_DIR/sources.nix"

OLD_GO_VENDOR_HASH="$(instantiateClean authelia.vendorHash)"
echo "Old go vendor hash $OLD_GO_VENDOR_HASH"
replace "$OLD_GO_VENDOR_HASH" "$TMP_HASH" "$DRV_DIR/sources.nix"
NEW_GO_VENDOR_HASH="$(fetchNewHash authelia.goModules)"
echo "New go vendor hash $NEW_GO_VENDOR_HASH"
replace "$TMP_HASH" "$NEW_GO_VENDOR_HASH" "$DRV_DIR/sources.nix"
