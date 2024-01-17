# CI-related Scripts

This directory contains scripts and files used and related to the CI running the `pkgs/by-name` checks in Nixpkgs.
See also the [CI GitHub Action](../../../../.github/workflows/check-by-name.yml).

## `./run-local.sh BASE_BRANCH [REPOSITORY]`

Runs the `pkgs/by-name` check on the HEAD commit, closely matching what CI does.

Note that this can't do exactly the same as CI,
because CI needs to rely on GitHub's server-side Git history to compute the mergeability of PRs before the check can be started.
In turn when running locally, we don't want to have to push commits to test them,
and we can also rely on the local Git history to do the mergeability check.

Arguments:
- `BASE_BRANCH`: The base branch to use, e.g. master or release-23.11
- `REPOSITORY`: The repository to fetch the base branch from, defaults to https://github.com/NixOS/nixpkgs.git

## `./update-pinned-tool.sh`

Updates the pinned CI tool in [`./pinned-tool.json`](./pinned-tool.json) to the
[latest version from the `nixos-unstable` channel](https://hydra.nixos.org/job/nixos/trunk-combined/nixpkgs.tests.nixpkgs-check-by-name.x86_64-linux)

This script is called manually once the CI tooling needs to be updated.

## `./fetch-pinned-tool.sh OUTPUT_PATH`

Fetches the pinned tooling specified in [`./pinned-tool.json`](./pinned-tool.json).

This script is used both by [`./run-local.sh`](#run-local-sh-base-branch-repository) and CI.

Arguments:
- `OUTPUT_PATH`: The output symlink path for the tool
