#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq nix-prefetch

set -euxo pipefail

# provide a github token so you don't get rate limited
# if you use gh cli you can use:
#     `export GITHUB_TOKEN="$(cat ~/.config/gh/config.yml | yq '.hosts."github.com".oauth_token' -r)"`
# or just set your token by hand:
#     `read -s -p "Enter your token: " GITHUB_TOKEN; export GITHUB_TOKEN`
#     (we use read so it doesn't show in our shell history and in secret mode so the token you paste isn't visible)
if [ -z "${GITHUB_TOKEN:-}" ]; then
    echo "no GITHUB_TOKEN provided - you could meet API request limiting" >&2
fi

ROOT="$(dirname "$(readlink -f "$0")")"
NIXPKGS_ROOT="$ROOT/../../../.."

COMMON_FILE="$ROOT/common.nix"

instantiateClean() {
    nix-instantiate -A "$1" --eval --strict | cut -d\" -f2
}

# get latest version
NEW_VERSION=$(
  curl -s -H \
    "Accept: application/vnd.github.v3+json" \
    ${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
    https://api.github.com/repos/returntocorp/semgrep/releases/latest \
  | jq -r '.tag_name'
)
# trim v prefix
NEW_VERSION="${NEW_VERSION:1}"
OLD_VERSION="$(instantiateClean semgrep.passthru.common.version)"

if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
    echo "Already up to date"
    exit
fi

replace() {
    sed -i "s@$1@$2@g" "$3"
}

fetchgithub() {
    set +eo pipefail
    nix-build -A "$1" 2>&1 >/dev/null | grep "got:" | cut -d':' -f2 | sed 's| ||g'
    set -eo pipefail
}

fetch_arch() {
  VERSION=$1
  PLATFORM=$2
  nix-prefetch "{ fetchPypi }:
fetchPypi rec {
  pname = \"semgrep\";
  version = \"$VERSION\";
  format = \"wheel\";
  dist = python;
  python = \"cp37.cp38.cp39.cp310.cp311.py37.py38.py39.py310.py311\";
  platform = \"$PLATFORM\";
}
"
}

replace "$OLD_VERSION" "$NEW_VERSION" "$COMMON_FILE"

echo "Updating src"

OLD_HASH="$(instantiateClean semgrep.passthru.common.srcHash)"
echo "Old hash $OLD_HASH"
TMP_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
replace "$OLD_HASH" "$TMP_HASH" "$COMMON_FILE"
NEW_HASH="$(fetchgithub semgrep.src)"
echo "New hash $NEW_HASH"
replace "$TMP_HASH" "$NEW_HASH" "$COMMON_FILE"

echo "Updated src"


update_core_platform() {
    SYSTEM=$1
    echo "Updating core src $SYSTEM"

    PLATFORM="$(instantiateClean "semgrep.passthru.common.core.$SYSTEM.platform")"

    OLD_HASH="$(instantiateClean "semgrep.passthru.common.core.$SYSTEM.hash")"
    echo "Old core hash $OLD_HASH"
    NEW_HASH="$(fetch_arch "$NEW_VERSION" "$PLATFORM")"
    echo "New core hash $NEW_HASH"
    replace "$OLD_HASH" "$NEW_HASH" "$COMMON_FILE"

    echo "Updated core src $SYSTEM"
}

update_core_platform "x86_64-linux"
update_core_platform "x86_64-darwin"
update_core_platform "aarch64-darwin"

OLD_PWD=$PWD
TMPDIR="$(mktemp -d)"
# shallow clone to check submodule commits, don't actually need the submodules
git clone https://github.com/returntocorp/semgrep "$TMPDIR/semgrep" --depth 1 --branch "v$NEW_VERSION"

get_submodule_commit() {
    OLD_PWD=$PWD
    (
        cd "$TMPDIR/semgrep"
        git ls-tree --object-only HEAD "$1"
        cd "$OLD_PWD"
    )
}

# loop through submodules
nix-instantiate -E "with import $NIXPKGS_ROOT {}; builtins.attrNames semgrep.passthru.common.submodules" --eval --strict --json \
| jq '.[]' -r \
| while read -r SUBMODULE; do
    echo "Updating $SUBMODULE"
    OLD_REV=$(instantiateClean semgrep.passthru.common.submodules."$SUBMODULE".rev)
    echo "Old commit $OLD_REV"
    OLD_HASH=$(instantiateClean semgrep.passthru.common.submodules."$SUBMODULE".hash)
    echo "Old hash $OLD_HASH"

    NEW_REV=$(get_submodule_commit "$SUBMODULE")
    echo "New commit $NEW_REV"

    if [[ "$OLD_REV" == "$NEW_REV" ]]; then
      echo "$SUBMODULE already up to date"
      continue
    fi

    TMP_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
    replace "$OLD_REV" "$NEW_REV" "$COMMON_FILE"
    replace "$OLD_HASH" "$TMP_HASH" "$COMMON_FILE"
    NEW_HASH="$(fetchgithub semgrep.passthru.submodulesSubset."$SUBMODULE")"
    echo "New hash $NEW_HASH"
    replace "$TMP_HASH" "$NEW_HASH" "$COMMON_FILE"

    echo "Updated $SUBMODULE"
done

rm -rf "$TMPDIR"

echo "Finished"

