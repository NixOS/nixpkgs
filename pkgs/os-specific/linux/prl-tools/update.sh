#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq libxml2

set -eu -o pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
path="$nixpkgs/pkgs/os-specific/linux/prl-tools/default.nix"

# Currently this script only supports Parallels 26
# Please change the knowledge base url after each major release
kb_url="https://kb.parallels.com/en/131014"
content="$(curl -s "$kb_url")"

# Extract all version/build pairs and select the latest (by semver, then build)
# Prefer the article content; fallback to whole body text
article_text="$(echo "$content" | xmllint --recover --html --xpath 'string(//div[@id="article-content"])' - 2>/dev/null || true)"
if [[ -z "${article_text:-}" ]]; then
  article_text="$(echo "$content" | xmllint --recover --html --xpath 'string(//body)' - 2>/dev/null || echo "$content")"
fi

# Find all "X.Y.Z (BUILD)" occurrences like "20.4.1 (55996)"
mapfile -t candidates < <(echo "$article_text" \
  | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+[[:space:]]*\(([0-9]+)\)' \
  | sed -E 's/([0-9]+\.[0-9]+\.[0-9]+)[[:space:]]*\(([0-9]+)\)/\1 \2/' \
  | sort -u)

if [[ ${#candidates[@]} -eq 0 ]]; then
  echo "Failed to extract any version from $kb_url" >&2
  exit 1
fi

# Sort by version then build and pick the highest
latest_pair="$(printf '%s\n' "${candidates[@]}" | sort -V -k1,1 -k2,2n | tail -n1)"
latest_ver="$(awk '{print $1}' <<< "$latest_pair")"
latest_build="$(awk '{print $2}' <<< "$latest_pair")"
version="${latest_ver}-${latest_build}"
echo "Found latest version: $version"

# Extract and compare current version
old_version="$(grep -o 'version = ".*"' "$path" | awk -F'"' '{print $2}')"
if [[ "$old_version" > "$version" || "$old_version" == "$version" ]]; then
    echo "Current version $old_version is up-to-date"
    exit 0
fi

# Update version and hash
major_version="$(echo "$version" | cut -d. -f1)"
dmg_url="https://download.parallels.com/desktop/v${major_version}/${version}/ParallelsDesktop-${version}.dmg"
sha256="$(nix store prefetch-file "$dmg_url" --json | jq -r '.hash')"
sed -i -e "s,version = \"$old_version\",version = \"$version\"," \
    -e "s,hash = \"sha256-.*\",hash = \"$sha256\"," "$path"

echo "Updated linuxPackages_latest.prl-tools $old_version -> $version"
