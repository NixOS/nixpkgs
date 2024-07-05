# `pkgs/by-name` check CI scripts

This directory contains scripts and files used and related to the CI running the `pkgs/by-name` checks in Nixpkgs.
See also the [CI GitHub Action](../../../.github/workflows/check-by-name.yml).

## `./run-local.sh BASE_BRANCH [REPOSITORY]`

Runs the `pkgs/by-name` check on the HEAD commit, closely matching what CI does.

Note that this can't do exactly the same as CI,
because CI needs to rely on GitHub's server-side Git history to compute the mergeability of PRs before the check can be started.
In turn when running locally, we don't want to have to push commits to test them,
and we can also rely on the local Git history to do the mergeability check.

Arguments:
- `BASE_BRANCH`: The base branch to use, e.g. master or release-24.05
- `REPOSITORY`: The repository to fetch the base branch from, defaults to https://github.com/NixOS/nixpkgs.git

## `./update-pinned-tool.sh`

Updates the pinned [nixpkgs-check-by-name tool](https://github.com/NixOS/nixpkgs-check-by-name) in [`./pinned-version.txt`](./pinned-version.txt) to the latest [release](https://github.com/NixOS/nixpkgs-check-by-name/releases).
Each release contains a pre-built x86_64-linux version of the tool which is used by CI.

This script currently needs to be called manually when the CI tooling needs to be updated.

Why not just build the tooling right from the PRs Nixpkgs version?
- Because it allows CI to check all PRs, even if they would break the CI tooling.
- Because it makes the CI check very fast, since no Nix builds need to be done, even for mass rebuilds.
- Because it improves security, since we don't have to build potentially untrusted code from PRs.
  The tool only needs a very minimal Nix evaluation at runtime, which can work with [readonly-mode](https://nixos.org/manual/nix/stable/command-ref/opt-common.html#opt-readonly-mode) and [restrict-eval](https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-restrict-eval).

