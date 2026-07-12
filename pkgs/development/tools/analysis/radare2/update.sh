#!/usr/bin/env nix-shell
#!nix-shell -i sh -p curl jq nix-prefetch-github nix coreutils gnused gnugrep
# shellcheck shell=sh
set -eu

# Directory of this script / the radare2 package
SCRIPT_DIR="$(readlink -f "$(dirname "$0")")"
NIXFILE="$SCRIPT_DIR/default.nix"

# Determine latest release version
LATEST_VERSION=$(curl -s https://api.github.com/repos/radareorg/radare2/releases/latest | jq -r '.tag_name')
echo "Latest radare2 version: $LATEST_VERSION"

CURRENT_VERSION=$(grep 'version = ' "$NIXFILE" | head -1 | sed 's/.*"\(.*\)".*/\1/')
echo "Current radare2 version: $CURRENT_VERSION"

if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ]; then
    echo "radare2 is already up to date"
    exit 0
fi

# Update main package version and hash
echo "Updating main source to $LATEST_VERSION..."
MAIN_HASH=$(nix-prefetch-github radare radare2 --rev "$LATEST_VERSION" --json | jq -r '.hash')
echo "  New main hash: $MAIN_HASH"

sed -i "s|version = \"$CURRENT_VERSION\"|version = \"$LATEST_VERSION\"|" "$NIXFILE"
sed -i "/src = fetchFromGitHub/,/};/{s|hash = \".*\"|hash = \"$MAIN_HASH\"|}" "$NIXFILE"

# Update a single subproject
# Arguments: name owner repo wrap_file ref_type
update_subproject() {
    name=$1
    owner=$2
    repo=$3
    wrap_file=$4
    ref_type=$5

    echo "Checking subproject $name..."

    # Fetch the wrap file from the new version
    wrap_content=$(curl -sL "https://raw.githubusercontent.com/radareorg/radare2/$LATEST_VERSION/subprojects/$wrap_file")
    new_rev=$(echo "$wrap_content" | grep '^revision' | sed 's/revision = //')

    # Get the current revision from the nix file
    current_rev=$(grep -A3 "repo = \"$repo\"" "$NIXFILE" | grep "$ref_type = " | sed 's/.*"\(.*\)".*/\1/')

    if [ "$new_rev" = "$current_rev" ]; then
        echo "  $name is unchanged at $current_rev"
        return
    fi

    echo "  Updating $name: $current_rev -> $new_rev"

    # Prefetch new hash
    new_hash=$(nix-prefetch-github "$owner" "$repo" --rev "$new_rev" --json | jq -r '.hash')
    echo "  New hash: $new_hash"

    # Update revision and hash in the nix file
    sed -i "/repo = \"$repo\"/,/};/{s|$ref_type = \"$current_rev\"|$ref_type = \"$new_rev\"|}" "$NIXFILE"
    sed -i "/repo = \"$repo\"/,/};/{s|hash = \".*\"|hash = \"$new_hash\"|}" "$NIXFILE"
}

update_subproject binaryninja Vector35 binaryninja-api binaryninja.wrap rev
update_subproject sdb radareorg sdb sdb.wrap tag
update_subproject qjs quickjs-ng quickjs qjs.wrap rev

echo "Update iaito to follow new radare2 version '$LATEST_VERSION'"
IAITO_UPDATE_SCRIPT="$(readlink -f "$(dirname "$SCRIPT_DIR")/../../../by-name/ia/iaito/update.sh")"
if "$IAITO_UPDATE_SCRIPT" "$LATEST_VERSION";then
    echo "iaito updated to $LATEST_VERSION"
else
    # iaito release may not have been published yet, release dates are not in sync
    # sometimes, iaito is released earlier than radare2
    echo "failed to update iaito to $LATEST_VERSION, continuing"
fi

echo "Update complete. Please verify with: nix build .#radare2 .#iaito"
