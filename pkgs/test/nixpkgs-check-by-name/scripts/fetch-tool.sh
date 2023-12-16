#!/usr/bin/env bash
# Fetches the prebuilt nixpkgs-check-by-name to use from
# the NixOS channel corresponding to the given base branch

set -euo pipefail

if (( $# < 2 )); then
    echo >&2 "Usage: $0 BASE_BRANCH OUTPUT_PATH"
    echo >&2 "BASE_BRANCH: The base branch to use, e.g. master or release-23.11"
    echo >&2 "OUTPUT_PATH: The output symlink path for the tool"
    exit 1
fi
baseBranch=$1
output=$2

echo >&2 -n "Determining the channel to use for PR base branch $baseBranch.. "
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
    echo >&2 "$channel"
else
    # Fall back to nixos-unstable, makes sense for fresh release branches
    channel=nixos-unstable
    echo >&2 -e "\e[33mWarning: Preferred channel $preferredChannel could not be fetched, using fallback: $channel\e[0m"
fi

echo >&2 -n "Fetching latest version of channel $channel.. "
# This is probably the easiest way to get Nix to output the path to a downloaded channel!
nixpkgs=$(nix-instantiate --find-file nixpkgs -I nixpkgs=channel:"$channel")
echo >&2 "$nixpkgs"

# This file only exists in channels
echo >&2 -e "Git revision of channel $channel is \e[34m$(<"$nixpkgs/.git-revision")\e[0m"

echo >&2 -n "Fetching the prebuilt version of nixpkgs-check-by-name.. "
nix-build -o "$output" "$nixpkgs" -A tests.nixpkgs-check-by-name -j 0 >/dev/null
realpath >&2 "$output"
