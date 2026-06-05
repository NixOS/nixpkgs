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

# Get path to the info.json file. If called with
# nix-shell maintainers/scripts/update.nix --argstr package PKG_NAME
# returns the path in nixpkgs. If not, returns the current working directory
info_json_path() {
    if [ -z "${UPDATE_NIX_ATTR_PATH+x}" ]; then
        echo "info.json"
    else
        nixFile=$(nix-instantiate --eval --strict -A "$UPDATE_NIX_ATTR_PATH.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')
        echo "$(dirname "$nixFile")/info.json"
    fi
}

# Input:
#  - fetcher: fetcher name. E.g.: fetchFromGitHub, fetchgit, ...
#  - url: Upstream URL. E.g: https://github.com/NixOS/nix
#  - version: Version to fetch. E.g.: 1.0
#  - submodules: Fetch submodules, true or false.
# Output:
#  Generates a info.json file in the current working directory
update_info() {
    fetcher=$1
    url=$2
    version=$3
    submodules=$4

    nurl_out=$(nurl --json --fetcher "$fetcher" "--submodules=$submodules" "$url" "$version")
    info_json=$(info_json_path)

    jq -n \
        --arg fetcher "$fetcher" \
        --argjson nurl_out "$nurl_out" \
        --arg version "$(derivation_version "$version")" \
        '{"fetcher": $fetcher,
          "fetcherArgs": ($nurl_out.args),
          "version": $version
         }' >"$info_json"
}
