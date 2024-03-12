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
[latest version from the `nixos-unstable` channel](https://hydra.nixos.org/job/nixos/trunk-combined/nixpkgs.tests.nixpkgs-check-by-name.x86_64-linux).

This script needs to be called manually when the CI tooling needs to be updated.

The `pinned-tool.json` file gets populated with both:
- The `/nix/store` path for `x86_64-linux`, such that CI doesn't have to evaluate Nixpkgs and can directly fetch it from the cache instead.
- The Nixpkgs revision, such that the `./run-local.sh` script can be used to run the checks locally on any system.

To ensure that the tool is always pre-built for `x86_64-linux` in the `nixos-unstable` channel,
it's included in the `tested` jobset description in [`nixos/release-combined.nix`](../../../nixos/release-combined.nix).

Why not just build the tooling right from the PRs Nixpkgs version?
- Because it allows CI to check all PRs, even if they would break the CI tooling.
- Because it makes the CI check very fast, since no Nix builds need to be done, even for mass rebuilds.
- Because it improves security, since we don't have to build potentially untrusted code from PRs.
  The tool only needs a very minimal Nix evaluation at runtime, which can work with [readonly-mode](https://nixos.org/manual/nix/stable/command-ref/opt-common.html#opt-readonly-mode) and [restrict-eval](https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-restrict-eval).

