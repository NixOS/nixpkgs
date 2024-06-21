# shellcheck shell=bash

set -eu
set -o pipefail

get_last_github_tag() {
    repo=$1
    domain=${2:-github.com}
    curl -s "https://api.${domain}/repos/${repo}/tags" | jq -r '.[0].name'
}

get_last_git_tag() {
    repo=$1
    git -c 'versionsort.suffix=-' \
        ls-remote --exit-code --refs --sort='version:refname' --tags "$repo" |
        tail --lines=1 |
        cut --delimiter='/' --fields=3
}

# Convert a version string to a derivation version
# e.g.: v1.0 -> 1.0
derivation_version() {
    version=$1
    echo "${version#v}"
}

# Input:
#  - fetcher: fetcher name. E.g.: fetchFromGitHub, fetchgit, ...
#  - url: Upstream URL. E.g: https://github.com/NixOS/nix
#  - version: Version to fetch. E.g.: 1.0
#  - submodules: Fetch submodules, true or false.
# Output:
#  JSON with fetcher name, fetcher arguments, version and nix prefetch command
get_nurl_info() {
    fetcher=$1
    url=$2
    version=$3
    submodules=$4

    tmp_file="$(mktemp)"
    trap 'rm -rf -- "$tmp_file"' EXIT

    nurl_out=$(nurl --json --fetcher "$fetcher" "--submodules=$submodules" "$url" "$version" 2> >(tee "$tmp_file" >&2))
    nix_prefetch_cmd=$(cat "$tmp_file")

    # Remove '$ ' from the command
    nix_prefetch_cmd=${nix_prefetch_cmd#"$ "}

    jq -n \
        --arg fetcher "$fetcher" \
        --argjson nurl_out "$nurl_out" \
        --arg nix_prefetch_cmd "$nix_prefetch_cmd" \
        --arg version "$(derivation_version "$version")" \
        '{"fetcher": $fetcher,
          "fetcher_args": ($nurl_out.args),
          "nix_prefetch_cmd": $nix_prefetch_cmd,
          "version": $version
         }'
}

# Input:
#  - user_args: fetcherArgs values defined by the user
#  - sync_files: list of files to sync defined by the user
#  - nurl_info: get_nurl_info output
# Output:
#  Copies syncFiles, and generates a info.json file in the current working directory
update_info() {
    user_args=$1
    sync_files=$2
    nurl_info=$3

    nix_prefetch_cmd="$(jq -r ".nix_prefetch_cmd" <<<"$nurl_info")"
    storePath="$(eval "$nix_prefetch_cmd" | jq -r ".storePath")"

    # JSON array to bash array
    declare -a sync_files_array
    mapfile -t sync_files_array < <(jq -r ".[]" <<<"$sync_files")

    for f in "${sync_files_array[@]}"; do
        cp -r --no-preserve=mode "${storePath}/${f}" .
    done

    jq -n \
        --argjson user_args "$user_args" \
        --argjson sync_files "$sync_files" \
        --argjson nurl_info "$nurl_info" \
        '{"fetcher": ($nurl_info.fetcher),
          "fetcherArgs": ($user_args + $nurl_info.fetcher_args),
          "syncFiles": $sync_files,
          "version": ($nurl_info.version)
         }' >info.json
}
