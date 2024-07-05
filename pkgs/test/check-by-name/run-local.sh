#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq

set -o pipefail -o errexit -o nounset

trace() { echo >&2 "$@"; }

tmp=$(mktemp -d)
cleanup() {
    # Don't exit early if anything fails to cleanup
    set +o errexit

    trace -n "Cleaning up.. "

    [[ -e "$tmp/base" ]] && git worktree remove --force "$tmp/base"
    [[ -e "$tmp/merged" ]] && git worktree remove --force "$tmp/merged"

    rm -rf "$tmp"

    trace "Done"
}
trap cleanup exit


repo=https://github.com/NixOS/nixpkgs.git

if (( $# != 0 )); then
    baseBranch=$1
    shift
else
    trace "Usage: $0 BASE_BRANCH [REPOSITORY]"
    trace "BASE_BRANCH: The base branch to use, e.g. master or release-23.11"
    trace "REPOSITORY: The repository to fetch the base branch from, defaults to $repo"
    exit 1
fi

if (( $# != 0 )); then
    repo=$1
    shift
fi

if [[ -n "$(git status --porcelain)" ]]; then
    trace -e "\e[33mWarning: Dirty tree, uncommitted changes won't be taken into account\e[0m"
fi
headSha=$(git rev-parse HEAD)
trace -e "Using HEAD commit \e[34m$headSha\e[0m"

trace -n "Creating Git worktree for the HEAD commit in $tmp/merged.. "
git worktree add --detach -q "$tmp/merged" HEAD
trace "Done"

trace -n "Fetching base branch $baseBranch to compare against.. "
git fetch -q "$repo" refs/heads/"$baseBranch"
baseSha=$(git rev-parse FETCH_HEAD)
trace -e "\e[34m$baseSha\e[0m"

trace -n "Creating Git worktree for the base branch in $tmp/base.. "
git worktree add -q "$tmp/base" "$baseSha"
trace "Done"

trace -n "Merging base branch into the HEAD commit in $tmp/merged.. "
git -C "$tmp/merged" merge -q --no-edit "$baseSha"
trace -e "\e[34m$(git -C "$tmp/merged" rev-parse HEAD)\e[0m"

trace -n "Reading pinned nixpkgs-check-by-name version from pinned-version.txt.. "
toolVersion=$(<"$tmp/merged/pkgs/test/check-by-name/pinned-version.txt")
trace -e "\e[34m$toolVersion\e[0m"

trace -n "Building tool.. "
nix-build https://github.com/NixOS/nixpkgs-check-by-name/tarball/"$toolVersion" -o "$tmp/tool" -A build

trace "Running nixpkgs-check-by-name.."
"$tmp/tool/bin/nixpkgs-check-by-name" --base "$tmp/base" "$tmp/merged"
