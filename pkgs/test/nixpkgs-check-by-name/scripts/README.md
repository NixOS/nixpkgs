# CI-related Scripts

This directory contains scripts used and related to the CI running the `pkgs/by-name` checks in Nixpkgs. See also the [CI GitHub Action](../../../../.github/workflows/check-by-name.yml).

## `./run-local.sh BASE_BRANCH [REPOSITORY]`

Runs the `pkgs/by-name` check on the HEAD commit, closely matching what CI does.

Note that this can't do exactly the same as CI,
because CI needs to rely on GitHub's server-side Git history to compute the mergeability of PRs before the check can be started.
In turn when running locally, we don't want to have to push commits to test them,
and we can also rely on the local Git history to do the mergeability check.

Arguments:
- `BASE_BRANCH`: The base branch to use, e.g. master or release-23.11
- `REPOSITORY`: The repository to fetch the base branch from, defaults to https://github.com/NixOS/nixpkgs.git

## `./fetch-tool.sh BASE_BRANCH OUTPUT_PATH`

Fetches the Hydra-prebuilt nixpkgs-check-by-name to use from the NixOS channel corresponding to the given base branch.

This script is used both by [`./run-local.sh`](#run-local-sh-base-branch-repository) and CI.

Arguments:
- `BASE_BRANCH`: The base branch to use, e.g. master or release-23.11
- `OUTPUT_PATH`: The output symlink path for the tool
