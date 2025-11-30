#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p bash nix-prefetch curl jq gawk gnused nixfmt

set -euo pipefail

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
FILE_PATH="$SCRIPT_DIR/xanmod-kernels.nix"

get_old_version() {
    local file_path="$1"
    local variant="$2"

    grep -A 2 "$variant = {" "$file_path" | grep "version =" | cut -d '"' -f 2
}

VARIANT="${1:-lts}"
OLD_VERSION=${UPDATE_NIX_OLD_VERSION:-$(get_old_version "$FILE_PATH" "$VARIANT")}

RELEASES=$(curl --silent https://gitlab.com/api/v4/projects/xanmod%2Flinux/releases)

# list of URLs. latest first, oldest last
RELEASE_URLS=$(echo "$RELEASES" | jq '.[].assets.links.[0].name')

while IFS= read -r url; do
    # Remove trailing slash
    url="${url%/}"

    # Get variant, version and suffix from url fields:
    #                 8         9       NF
    #                 |         |       |
    # https://.../<variant>/<version>-<suffix>
    release_variant=$(echo "$url" | awk -F'[/-]' '{print $8}')
    release_version=$(echo "$url" | awk -F'[/-]' '{print $9}')

    # either xanmod1 or xanmod2
    suffix=$(echo "$url" | awk -F'[/-]' '{print $NF}')

    if [[ "$release_variant" == "$VARIANT" ]]; then
        if [[ "$release_version" == "$OLD_VERSION" ]]; then
            echo "Xanmod $VARIANT is up-to-date: ${OLD_VERSION}"
            exit 0
        else
            NEW_VERSION="$release_version"
            SUFFIX="$suffix"
            break
        fi
    fi
done < <(echo "$RELEASE_URLS" | jq -r)

>&2 echo "Updating Xanmod \"$VARIANT\" from $OLD_VERSION to $NEW_VERSION ($SUFFIX)"

URL="https://gitlab.com/api/v4/projects/xanmod%2Flinux/repository/archive.tar.gz?sha=$NEW_VERSION-$SUFFIX"
HASH="$(nix-prefetch fetchzip --quiet --url "$URL")"

update_variant() {
    local file_path="$1"
    local variant="$2"
    local new_version="$3"
    local new_hash="$4"
    local suffix="$5"

    # ${variant} = {      <- range start
    #   version = ...
    #   hash = ...
    #   suffix = ...
    # };                  <- range end
    range_start="^\s*$variant = {"
    range_end="^\s*};"

    # - Update the version and hash using sed range addresses
    # - Remove suffix line, if it exists
    sed -i -e "/$range_start/,/$range_end/ {
        s|^\s*version = \".*\";|      version = \"$new_version\";|;
        s|^\s*hash = \".*\";|      hash = \"$new_hash\";|;
         /^\s*suffix = /d
    }" "$file_path"

    # Add suffix, if it's different than xanmod1 (the default)
    if [[ "$suffix" != "xanmod1" ]]; then
        sed -i -e "/$range_start/,/$range_end/ {
            s|$range_end|      suffix = \"$suffix\";\n    };|;
        }" "$file_path"
    fi

    # Apply proper formatting
    nixfmt "$file_path"
}

update_variant "$FILE_PATH" "$VARIANT" "$NEW_VERSION" "$HASH" "$SUFFIX"

# Customize commit
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#supported-features
COMMIT_BODY="
- Changelog: https://dl.xanmod.org/changelog/${NEW_VERSION%.*}/ChangeLog-$NEW_VERSION-xanmod1.gz
- Diff: https://gitlab.com/xanmod/linux/-/compare/$OLD_VERSION-xanmod1..$NEW_VERSION-xanmod1?from_project_id=51590166
"

jq -n --arg commitBody "$COMMIT_BODY" '[$ARGS.named]'
