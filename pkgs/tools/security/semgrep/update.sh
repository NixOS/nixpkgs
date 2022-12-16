#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq

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
NIX_DRV="$ROOT/default.nix"

COMMON_FILE="$ROOT/common.nix"

instantiateClean() {
    nix-instantiate -A "$1" --eval --strict | cut -d\" -f2
}

# get latest version
NEW_VERSION=$(
  curl -s -H
    "Accept: application/vnd.github.v3+json" \
    ${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
    https://api.github.com/repos/returntocorp/semgrep/releases/latest \
  | jq -r '.tag_name'
)
# trim v prefix
NEW_VERSION="${NEW_VERSION:1}"
OLD_VERSION="$(instantiateClean semgrep.common.version)"

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

fetchzip() {
    set +eo pipefail
    nix-build -E "with import $NIXPKGS_ROOT {}; fetchzip {url = \"$1\"; sha256 = lib.fakeSha256; }" 2>&1 >/dev/null | grep "got:" | cut -d':' -f2 | sed 's| ||g'
    set -eo pipefail
}

replace "$OLD_VERSION" "$NEW_VERSION" "$COMMON_FILE"

echo "Updating src"

OLD_HASH="$(instantiateClean semgrep.common.src.outputHash)"
echo "Old hash $OLD_HASH"
TMP_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
replace "$OLD_HASH" "$TMP_HASH" "$COMMON_FILE"
NEW_HASH="$(fetchgithub semgrep.common.src)"
echo "New hash $NEW_HASH"
replace "$TMP_HASH" "$NEW_HASH" "$COMMON_FILE"

echo "Updated src"

# loop through platforms for core
nix-instantiate -E "with import $NIXPKGS_ROOT {}; builtins.attrNames semgrep.common.core.data" --eval --strict --json \
| jq '.[]' -r \
| while read -r PLATFORM; do
    echo "Updating core for $PLATFORM"
    SUFFIX=$(instantiateClean semgrep.common.core.data."$1".suffix "$PLATFORM")
    OLD_HASH=$(instantiateClean semgrep.common.core.data."$1".sha256 "$PLATFORM")
    echo "Old hash $OLD_HASH"

    NEW_URL="https://github.com/returntocorp/semgrep/releases/download/v$NEW_VERSION/semgrep-v$NEW_VERSION$SUFFIX"
    NEW_HASH="$(fetchzip "$NEW_URL")"
    echo "New hash $NEW_HASH"

    replace "$OLD_HASH" "$NEW_HASH" "$COMMON_FILE"

    echo "Updated core for $PLATFORM"
done

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
    OLD_HASH=$(instantiateClean semgrep.passthru.common.submodules."$SUBMODULE".outputHash)
    echo "Old hash $OLD_HASH"

    NEW_REV=$(get_submodule_commit "$SUBMODULE")
    echo "New commit $NEW_REV"

    if [[ "$OLD_REV" == "$NEW_REV" ]]; then
      echo "$SUBMODULE already up to date"
      continue
    fi

    NEW_URL=$(instantiateClean semgrep.passthru.common.submodules."$SUBMODULE".url | sed "s@$OLD_REV@$NEW_REV@g")
    NEW_HASH=$(nix --experimental-features nix-command hash to-sri "sha256:$(nix-prefetch-url "$NEW_URL")")

    TMP_HASH="sha256-ABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
    replace "$OLD_REV" "$NEW_REV" "$COMMON_FILE"
    replace "$OLD_HASH" "$TMP_HASH" "$COMMON_FILE"
    NEW_HASH="$(fetchgithub semgrep.passthru.common.submodules."$SUBMODULE")"
    echo "New hash $NEW_HASH"
    replace "$TMP_HASH" "$NEW_HASH" "$COMMON_FILE"

    echo "Updated $SUBMODULE"
done

rm -rf "$TMPDIR"

echo "Finished"

