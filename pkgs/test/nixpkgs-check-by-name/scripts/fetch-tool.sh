#!/usr/bin/env bash
# Legacy script to make CI work for the PR that replaces this
# Needed due to `.github/workflows/check-by-name.yml` using `pull_request_target`,
# which uses the workflow from the base branch, which still uses this script.
# This file can be removed after the PR replacing it is merged.

trace() { echo >&2 "$@"; }

if (( $# < 2 )); then
    trace "Usage: $0 BASE_BRANCH OUTPUT_PATH"
    trace "BASE_BRANCH (unused): The base branch to use, e.g. master or release-23.11"
    trace "OUTPUT_PATH: The output symlink path for the tool"
    exit 1
fi
output=$2

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

"$SCRIPT_DIR"/fetch-pinned-tool.sh "$output"
