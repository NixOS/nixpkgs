#!/usr/bin/env bash

set -e
# Usage: pkgs/test/nixpkgs-check-by-name/reproduce.sh <base SHA> <tooling SHA> <merged SHA>

# TODO(amjoseph): allow omitting the final argument, since it is
# often a commit which exists only in github (and is difficult to
# `git fetch` from github before the PR is merged).

baseSha="$1"
toolingBinariesSha="$2"
mergedSha="$3"

nixpkgs_for_tooling_binaries=$(nix-instantiate --eval --expr "builtins.fetchTarball \"https://github.com/nixos/nixpkgs/archive/$toolingBinariesSha.tar.gz\"" | tr -d '"')

nix-store --realise --add-root nixpkgs-for-tooling-binaries $nixpkgs_for_tooling_binaries

echo "Fetching pre-built nixpkgs-check-by-name from channel $channel at revision $toolingBinariesSha"
nix-build \
  --option extra-substituters https://cache.nixos.org \
  --option trusted-public-keys 'cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=' \
  nixpkgs-for-tooling-binaries \
  -A tests.nixpkgs-check-by-name \
  --max-jobs 0

echo "Checking whether the check succeeds on the base branch $GITHUB_BASE_REF"
git checkout -q "$baseSha"
if baseOutput=$(result/bin/nixpkgs-check-by-name . 2>&1); then
    baseSuccess=1
else
    baseSuccess=
fi
printf "%s\n" "$baseOutput"

echo "Checking whether the check would succeed after merging this pull request"
git checkout -q "$mergedSha"
if mergedOutput=$(result/bin/nixpkgs-check-by-name . 2>&1); then
    mergedSuccess=1
    exitCode=0
else
    mergedSuccess=
    exitCode=1
fi
printf "%s\n" "$mergedOutput"

resultToEmoji() {
    if [[ -n "$1" ]]; then
        echo ":heavy_check_mark:"
    else
        echo ":x:"
    fi
}

# Print a markdown summary in GitHub actions
{
    echo "| Nixpkgs version | Check result |"
    echo "| --- | --- |"
    echo "| Latest base commit | $(resultToEmoji "$baseSuccess") |"
    echo "| After merging this PR | $(resultToEmoji "$mergedSuccess") |"
    echo ""

    if [[ -n "$baseSuccess" ]]; then
        if [[ -n "$mergedSuccess" ]]; then
            echo "The check succeeds on both the base branch and after merging this PR"
        else
            echo "The check succeeds on the base branch, but would fail after merging this PR:"
            echo "\`\`\`"
            echo "$mergedOutput"
            echo "\`\`\`"
            echo ""
        fi
    else
        if [[ -n "$mergedSuccess" ]]; then
            echo "The check fails on the base branch, but this PR fixes it, nicely done!"
        else
            echo "The check fails on both the base branch and after merging this PR, unknown if only this PRs changes would satisfy the check, the base branch needs to be fixed first."
            echo ""
            echo "Failure on the base branch:"
            echo "\`\`\`"
            echo "$baseOutput"
            echo "\`\`\`"
            echo ""
            echo "Failure after merging this PR:"
            echo "\`\`\`"
            echo "$mergedOutput"
            echo "\`\`\`"
            echo ""
        fi
    fi

    echo "### Details"
    echo "- nixpkgs-check-by-name tool binaries:"
    echo "  - Channel: $channel"
    echo "  - Tooling binaries built at nixpkgs commit: [$toolingBinariesSha](https://github.com/${GITHUB_REPOSITORY}/commit/$toolingBinariesSha)"
    echo "  - Store path: \`$(realpath result)\`"
    echo "- Tested Nixpkgs:"
    echo "  - Base branch: $BASE_SHA"
    echo "  - Latest base branch commit: [$baseSha](https://github.com/${GITHUB_REPOSITORY}/commit/$baseSha)"
    echo "  - Latest PR commit: [$headSha](https://github.com/${GITHUB_REPOSITORY}/commit/$headSha)"
    echo "  - Merge commit: [$mergedSha](https://github.com/${GITHUB_REPOSITORY}/commit/$mergedSha)"
} | tee -a "${GITHUB_STEP_SUMMARY:-/dev/null}"

exit "$exitCode"
