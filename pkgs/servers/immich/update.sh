#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq prefetch-npm-deps nix-prefetch-git nix-prefetch-github coreutils

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ -v GITHUB_TOKEN ]]; then
    TOKEN_ARGS=(--header "Authorization: token $GITHUB_TOKEN")
fi

old_version=$(jq -r ".version" sources.json || echo -n "0.0.1")
version=$(curl "${TOKEN_ARGS[@]}" -s "https://api.github.com/repos/immich-app/immich/releases/latest" | jq -r ".tag_name")
version="${version#v}"

if [[ "$old_version" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

src_hash=$(nix-prefetch-github immich-app immich --rev "v${version}" | jq -r .hash)
upstream_src="https://raw.githubusercontent.com/immich-app/immich/v$version"

sources_tmp="$(mktemp)"
cat <<EOF > "$sources_tmp"
{
  "version": "$version",
  "hash": "$src_hash",
  "components": {}
}
EOF

for npm_component in cli server web; do
    hash=$(prefetch-npm-deps <(curl "${TOKEN_ARGS[@]}" -s "$upstream_src/$npm_component/package-lock.json"))
    echo "$(jq --arg npm_component "$npm_component" \
      --arg hash "$hash" \
      '.components += {($npm_component): {npmDepsHash: $hash}}' \
      "$sources_tmp")" > "$sources_tmp"
done

cp "$sources_tmp" sources.json
