#!/usr/bin/env bash
# For pull_request_target this is the same as $GITHUB_SHA
echo "baseSha=$(git rev-parse HEAD^1)" >> "$GITHUB_ENV"

echo "headSha=$(git rev-parse HEAD^2)" >> "$GITHUB_ENV"
