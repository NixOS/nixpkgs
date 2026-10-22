#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix
set -eu

script_dir="$(dirname "$(readlink -f "$0")")"
filename="$script_dir/git.nix"
temp_hash="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

function update_version_and_rev() {
    local commit_json="$(curl -s "https://git.lix.systems/api/v1/repos/lix-project/lix/commits?sha=main" | jq -r '.[0]')"
    local old_sha="$(nix-instantiate --eval --raw -A "$UPDATE_NIX_ATTR_PATH.src.rev")"
    local new_sha="$(echo "$commit_json" | jq -r '.sha')"
    local date_of_commit="$(echo "$commit_json" | jq -r '.commit.committer.date')"
    local short_date="$(date -d "$date_of_commit" +%Y%m%d)"
    local version_json="$(curl -s "https://git.lix.systems/lix-project/lix/raw/commit/$new_sha/version.json")"
    local old_version_prefix="$(nix-instantiate --eval --raw -A "$UPDATE_NIX_ATTR_PATH.version" | sed 's/_[0-9a-f]\{12\}//')"
    local new_version_prefix=$(echo "$version_json" | jq -r '.version' | sed "s/-dev/-pre-$short_date/")
    sed -i "s/$old_version_prefix/$new_version_prefix/" "$filename"
    sed -i "s/$old_sha/$new_sha/" "$filename"
}

function update_hash() {
    local old_hash="$(nix-instantiate --eval --raw -A "$2")"
    sed -i "s/$old_hash/$temp_hash/" "$filename"
    local new_hash="$(nix-build --no-out-link -A "$1" |& grep "got:" | cut -d':' -f2 | sed 's| ||g')"
    sed -i "s/$temp_hash/$new_hash/" "$filename"
}

update_version_and_rev
update_hash "$UPDATE_NIX_ATTR_PATH.src" "$UPDATE_NIX_ATTR_PATH.src.hash"
update_hash "$UPDATE_NIX_ATTR_PATH.cargoDeps" "$UPDATE_NIX_ATTR_PATH.cargoDeps.vendorStaging.outputHash" --ignore-same-hash
