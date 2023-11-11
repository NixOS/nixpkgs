#!/usr/bin/env bash
echo "Determining which channel to use for PR base branch $GITHUB_BASE_REF"
if [[ "$GITHUB_BASE_REF" =~ ^(release|staging|staging-next)-([0-9][0-9]\.[0-9][0-9])$ ]]; then
    # Use the release channel for all PRs to release-XX.YY, staging-XX.YY and staging-next-XX.YY
    channel=nixos-${BASH_REMATCH[2]}
    echo "PR is for a release branch, using release channel $channel"
else
    # Use the nixos-unstable channel for all other PRs
    channel=nixos-unstable
    echo "PR is for a non-release branch, using unstable channel $channel"
fi
echo "channel=$channel" >> "$GITHUB_ENV"
