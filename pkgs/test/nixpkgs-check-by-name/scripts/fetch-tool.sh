#!/usr/bin/env bash
# Fetches the prebuilt nixpkgs-check-by-name to use from
# the NixOS channel corresponding to the given base branch

set -o pipefail -o errexit -o nounset

trace() { echo >&2 "$@"; }

if (( $# < 2 )); then
    trace "Usage: $0 BASE_BRANCH OUTPUT_PATH"
    trace "BASE_BRANCH: The base branch to use, e.g. master or release-23.11"
    trace "OUTPUT_PATH: The output symlink path for the tool"
    exit 1
fi
baseBranch=$1
output=$2

trace -n "Determining the channel to use for PR base branch $baseBranch.. "
if [[ "$baseBranch" =~ ^(release|staging|staging-next)-([0-9][0-9]\.[0-9][0-9])$ ]]; then
  # Use the release channel for all PRs to release-XX.YY, staging-XX.YY and staging-next-XX.YY
  preferredChannel=nixos-${BASH_REMATCH[2]}
else
  # Use the nixos-unstable channel for all other PRs
  preferredChannel=nixos-unstable
fi

# Check that the channel exists. It doesn't exist for fresh release branches
if curl -fSs "https://channels.nixos.org/$preferredChannel"; then
    channel=$preferredChannel
    trace "$channel"
else
    # Fall back to nixos-unstable, makes sense for fresh release branches
    channel=nixos-unstable
    trace -e "\e[33mWarning: Preferred channel $preferredChannel could not be fetched, using fallback: $channel\e[0m"
fi

trace -n "Fetching latest version of channel $channel.. "
# This is probably the easiest way to get Nix to output the path to a downloaded channel!
nixpkgs=$(nix-instantiate --find-file nixpkgs -I nixpkgs=channel:"$channel")
trace "$nixpkgs"

# This file only exists in channels
trace -e "Git revision of channel $channel is \e[34m$(<"$nixpkgs/.git-revision")\e[0m"

trace -n "Fetching the prebuilt version of nixpkgs-check-by-name.. "
nix-build -o "$output" "$nixpkgs" -A tests.nixpkgs-check-by-name -j 0 >/dev/null
realpath "$output" >&2
