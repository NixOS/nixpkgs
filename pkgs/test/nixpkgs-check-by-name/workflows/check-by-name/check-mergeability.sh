#!/usr/bin/env bash
# This checks for mergeability of a pull request as recommended in
# https://docs.github.com/en/rest/guides/using-the-rest-api-to-interact-with-your-git-database?apiVersion=2022-11-28#checking-mergeability-of-pull-requests

while true; do
    echo "Checking whether the pull request can be merged"
    prInfo=$(gh api \
                -H "Accept: application/vnd.github+json" \
                -H "X-GitHub-Api-Version: 2022-11-28" \
                /repos/"$GITHUB_REPOSITORY"/pulls/${{ github.event.pull_request.number }})
    mergeable=$(jq -r .mergeable <<< "$prInfo")
    mergedSha=$(jq -r .merge_commit_sha <<< "$prInfo")

    if [[ "$mergeable" == "null" ]]; then
        # null indicates that GitHub is still computing whether it's mergeable
        # Wait a couple seconds before trying again
        echo "GitHub is still computing whether this PR can be merged, waiting 5 seconds before trying again"
        sleep 5
    else
        break
    fi
done

if [[ "$mergeable" == "true" ]]; then
    echo "The PR can be merged, checking the merge commit $mergedSha"
else
    echo "The PR cannot be merged, it has a merge conflict"
    exit 1
fi
echo "mergedSha=$mergedSha" >> "$GITHUB_ENV"
