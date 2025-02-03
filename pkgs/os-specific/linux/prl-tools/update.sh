#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -eu -o pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
path="$nixpkgs/pkgs/os-specific/linux/prl-tools/default.nix"

# Currently this script only supports Parallels 20
# Please change the knowledge base url after each major release
kb_url="https://kb.parallels.com/en/130212"
content="$(curl -s "$kb_url")"

# Match latest version from Parallels knowledge base
regex='<meta property="og:description" content="[^"]*Parallels Desktop ([0-9]+) for Mac ([0-9]+\.[0-9]+\.[0-9+]) \(([0-9]+)\)[^"]*" />'
if [[ $content =~ $regex ]]; then
    major_version="${BASH_REMATCH[1]}"
    version="${BASH_REMATCH[2]}-${BASH_REMATCH[3]}"
    echo "Found latest version: $version, major version: $major_version"
else
    echo "Failed to extract version from $kb_url"
    exit 1
fi

# Extract and compare current version
old_version="$(grep -o 'version = ".*"' "$path" | awk -F'"' '{print $2}')"
if [[ "$old_version" > "$version" || "$old_version" == "$version" ]]; then
    echo "Current version $old_version is up-to-date"
    exit 0
fi

# Update version and hash
dmg_url="https://download.parallels.com/desktop/v${major_version}/${version}/ParallelsDesktop-${version}.dmg"
sha256="$(nix store prefetch-file $dmg_url --json | jq -r '.hash')"
sed -i -e "s/version = \"$old_version\"/version = \"$version\"/" \
    -e "s/hash = \"sha256-.*\"/hash = \"$sha256\"/" "$path"

git commit -qm "linuxPackages_latest.prl-tools: $old_version -> $version" "$path"
echo "Updated linuxPackages_latest.prl-tools $old_version -> $version"
