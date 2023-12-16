#!/usr/bin/env bash
# shellcheck disable=SC2016

set -euo pipefail

cleanup_commands=()
cleanup() {
    echo -n >&2 "Cleaning up.. "
    # Run all cleanup commands in inverse order
    for (( i=${#cleanup_commands[@]}-1; i>=0; i-- )); do
        eval "${cleanup_commands[i]}"
    done
    echo >&2 "Done"
}
trap cleanup exit

tmp=$(mktemp -d)
cleanup_commands+=('rmdir "$tmp"')

repo=https://github.com/NixOS/nixpkgs.git

if (( $# != 0 )); then
    baseBranch=$1
    shift
else
    echo >&2 "Usage: $0 BASE_BRANCH [REPOSITORY]"
    echo >&2 "BASE_BRANCH: The base branch to use, e.g. master or release-23.11"
    echo >&2 "REPOSITORY: The repository to fetch the base branch from, defaults to $repo"
    exit 1
fi

if (( $# != 0 )); then
    repo=$1
    shift
fi

if [[ -n "$(git status --porcelain)" ]]; then
    echo >&2 -e "\e[33mWarning: Dirty tree, uncommitted changes won't be taken into account\e[0m"
fi
headSha=$(git rev-parse HEAD)
echo >&2 -e "Using HEAD commit \e[34m$headSha\e[0m"

echo >&2 -n "Creating Git worktree for the HEAD commit in $tmp/merged.. "
git worktree add --detach -q "$tmp/merged" HEAD
cleanup_commands+=('git worktree remove --force "$tmp/merged"')
echo >&2 "Done"

echo >&2 -n "Fetching base branch $baseBranch to compare against.. "
git fetch -q "$repo" refs/heads/"$baseBranch"
baseSha=$(git rev-parse FETCH_HEAD)
echo >&2 -e "\e[34m$baseSha\e[0m"

echo >&2 -n "Creating Git worktree for the base branch in $tmp/base.. "
git worktree add -q "$tmp/base" "$baseSha"
cleanup_commands+=('git worktree remove --force "$tmp/base"')
echo >&2 "Done"

echo >&2 -n "Merging base branch into the HEAD commit in $tmp/merged.. "
git -C "$tmp/merged" merge -q --no-edit "$baseSha"
echo >&2 -e "\e[34m$(git -C "$tmp/merged" rev-parse HEAD)\e[0m"

"$tmp/merged/pkgs/test/nixpkgs-check-by-name/scripts/fetch-tool.sh" "$baseBranch" "$tmp/tool"
cleanup_commands+=('rm "$tmp/tool"')

echo >&2 "Running nixpkgs-check-by-name.."
"$tmp/tool/bin/nixpkgs-check-by-name" "$tmp/merged"
