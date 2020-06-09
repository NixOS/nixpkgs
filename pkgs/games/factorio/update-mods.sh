#!/usr/bin/env nix-shell
#! nix-shell -i bash -p jq nix coreutils curl
set -eu -o pipefail

# Lint: shellcheck -s bash update-mods.sh

# TODO:
# - Filter for stable and experimental mods by factorio_version (in info_json) in releases.

echo "Updating mods."

jq -r '.[].name' < mods.json | sort -u | while read -r name; do
    mod_json="$(curl -s https://mods.factorio.com/api/mods/"${name}"/full)"
    version="$(jq -r '.releases[] | .version' <<< "$mod_json" | sort -V | tail -n1)"
    echo "$name $version" 1>&2

    release_json="$(jq -r ".releases[] | select(.version == \"${version}\")" <<< "$mod_json")"

    info_json="$(jq '.info_json' <<< "$release_json")"
    dependencies="$(jq '.dependencies' <<< "$info_json")"

    jq "{ name: \"$name\", version, file_name, download_url, sha1, dependencies: $dependencies}" <<< "$release_json"
done | jq -s . > mods.new.json
mv mods.new.json mods.json

echo "Update successful."