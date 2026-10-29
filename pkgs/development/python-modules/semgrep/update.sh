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
    nix-instantiate "$NIXPKGS_ROOT" -A "$1" --eval --strict | cut -d\" -f2
}

# get latest version
NEW_VERSION=$(
  curl -s -L -H \
    "Accept: application/vnd.github.v3+json" \
    ${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
    https://api.github.com/repos/semgrep/semgrep/releases/latest \
  | jq -r '.tag_name'
)
# trim v prefix
NEW_VERSION="${NEW_VERSION:1}"
OLD_VERSION="$(instantiateClean semgrep.passthru.common.version)"

replace() {
    sed -i "s@$1@$2@g" "$3"
}

fetchgithub() {
    set +eo pipefail
    nix-build "$NIXPKGS_ROOT" -A "$1" 2>&1 >/dev/null | grep "got:" | cut -d':' -f2 | sed 's| ||g'
    set -eo pipefail
}

if [[ "$OLD_VERSION" != "$NEW_VERSION" ]]; then
    replace "$OLD_VERSION" "$NEW_VERSION" "$COMMON_FILE"
fi

echo "Fetching PyPI metadata for $NEW_VERSION"
PYPI_JSON=$(curl -s "https://pypi.org/pypi/semgrep/$NEW_VERSION/json")

# Update Python compatibility tag from any Linux wheel
NEW_PYTHON_TAG=$(echo "$PYPI_JSON" | jq -r '.urls[].filename' | grep 'manylinux' | head -n 1 | sed -E 's/semgrep-.*-(.*)-none-.*\.whl/\1/')
OLD_PYTHON_TAG=$(instantiateClean semgrep.passthru.common.pythonWheelTag)

if [[ "$OLD_PYTHON_TAG" != "$NEW_PYTHON_TAG" ]]; then
    echo "Updating Python wheel tag: $OLD_PYTHON_TAG -> $NEW_PYTHON_TAG"
    replace "$OLD_PYTHON_TAG" "$NEW_PYTHON_TAG" "$COMMON_FILE"
fi

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
    PYPI_ARCH=$2
    PYPI_DISTRO=$3
    echo "Updating core src $SYSTEM"

    OLD_PLATFORM="$(instantiateClean "semgrep.passthru.common.core.$SYSTEM.platform")"
    NEW_PLATFORM=$(echo "$PYPI_JSON" | jq -r '.urls[].filename' | grep "$PYPI_DISTRO" | grep "$PYPI_ARCH" | head -n 1 | sed -E 's/semgrep-.*-none-(.*)\.whl/\1/')

    if [[ -z "$NEW_PLATFORM" ]]; then
        echo "Error: Could not find platform tag for $SYSTEM ($PYPI_DISTRO, $PYPI_ARCH) on PyPI" >&2
        exit 1
    fi

    if [[ "$OLD_PLATFORM" != "$NEW_PLATFORM" ]]; then
        echo "Updating platform: $OLD_PLATFORM -> $NEW_PLATFORM"
        replace "$OLD_PLATFORM" "$NEW_PLATFORM" "$COMMON_FILE"
    fi

    OLD_HASH="$(instantiateClean "semgrep.passthru.common.core.$SYSTEM.hash")"
    URL="$(nix-instantiate "$NIXPKGS_ROOT" -A "semgrep.passthru.semgrep-core.src.url" --raw --eval --strict --argstr system "$SYSTEM")"
    echo "Old core hash $OLD_HASH"
    NEW_HASH="$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "$URL")")"
    echo "New core hash $NEW_HASH"
    replace "$OLD_HASH" "$NEW_HASH" "$COMMON_FILE"

    echo "Updated core src $SYSTEM"
}

# update_core_platform <nix-system> <pypi-arch> <pypi-distro>
update_core_platform "x86_64-linux" "x86_64" "manylinux"
update_core_platform "aarch64-linux" "aarch64" "manylinux"
update_core_platform "x86_64-darwin" "x86_64" "macosx"
update_core_platform "aarch64-darwin" "arm64" "macosx"

OLD_PWD=$PWD
TMPDIR="$(mktemp -d)"
# shallow clone to check submodule commits, don't actually need the submodules
git clone https://github.com/semgrep/semgrep "$TMPDIR/semgrep" --depth 1 --branch "v$NEW_VERSION"

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
