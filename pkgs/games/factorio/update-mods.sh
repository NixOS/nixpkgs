#!/usr/bin/env nix-shell
#! nix-shell -i bash -p jq nix coreutils curl
set -eu -o pipefail

# TODO:
# - Filter for stable and experimental mods by factorio_version (in info_json) in releases.

base_url="https://mods.factorio.com/"

echo "Updating mods."

cat mods.json | jq -r '.[].name' | sort -u | while read name; do
    mod_json="$(curl -s https://mods.factorio.com/api/mods/${name}/full)"
    version="$(jq -r '.releases[] | .version' <<< "$mod_json" | sort -V | tail -n1)"
    echo "$name $version" 1>&2

    release_json="$(jq -r ".releases[] | select(.version == \"${version}\")" <<< "$mod_json")"
    sha1="$(nix-hash --to-base32 --type sha1 "$(jq -r '.sha1' <<< "$release_json")")"

    dependencies="$(jq '.info_json' <<< "$release_json")"
    deps="$(jq '.dependencies | map(split(" ")[0] | select(. != "base" and (.|startswith("?")|not) and (.|startswith("(?)")|not) and (.|startswith("!")|not)))' <<< "$dependencies")"
    optionalDeps="$(jq '.dependencies | map(select(.|startswith("? ")) | split(" ")[1])' <<< "$dependencies")"

    jq "{
        name: \"$name\",
        version,
        file_name,
        download_url,
        sha1: \"$sha1\",
        deps: $deps,
        optionalDeps: $optionalDeps
    }" <<< "$release_json"
done | jq -s . > mods.new.json
mv mods.new.json mods.json

echo "Update successful."