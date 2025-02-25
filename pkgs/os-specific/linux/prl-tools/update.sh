#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq libxml2

set -eu -o pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
path="$nixpkgs/pkgs/os-specific/linux/prl-tools/default.nix"

# Currently this script only supports Parallels 20
# Please change the knowledge base url after each major release
kb_url="https://kb.parallels.com/en/130212"
content="$(curl -s "$kb_url")"

# Parse HTML content and retrieve og:description for header metadata
description=$(echo "$content" | xmllint --recover --html --xpath 'string(//meta[@property="og:description"]/@content)' - 2>/dev/null)
regex='[^0-9]+([0-9]+\.[0-9]+\.[0-9]+)[^\(]+\(([0-9]+)\)'
if [[ $description =~ $regex ]]; then
    version="${BASH_REMATCH[1]}-${BASH_REMATCH[2]}"
    echo "Found latest version: $version"
else
    echo "Failed to extract version from $kb_url" >&2
    echo "Retrived description: $description" >&2
    exit 1
fi

# Extract and compare current version
old_version="$(grep -o 'version = ".*"' "$path" | awk -F'"' '{print $2}')"
if [[ "$old_version" > "$version" || "$old_version" == "$version" ]]; then
    echo "Current version $old_version is up-to-date"
    exit 0
fi

# Update version and hash
major_version=$(echo $version | cut -d. -f1)
dmg_url="https://download.parallels.com/desktop/v${major_version}/${version}/ParallelsDesktop-${version}.dmg"
sha256="$(nix store prefetch-file $dmg_url --json | jq -r '.hash')"
sed -i -e "s,version = \"$old_version\",version = \"$version\"," \
    -e "s,hash = \"sha256-.*\",hash = \"$sha256\"," "$path"

echo "Updated linuxPackages_latest.prl-tools $old_version -> $version"
