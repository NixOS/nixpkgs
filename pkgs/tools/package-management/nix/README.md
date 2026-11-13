# Maintaining `nixVersions`

## Attributes

- `nixVersions.nix_2_X` and `nixVersions.nixComponents_2_X`: one per maintained release series.
- `nixVersions.latest`: the newest release series.
- `nixVersions.stable`: the series that `pkgs.nix` and NixOS use by default.
  It carries an extra test, `nix-fallback-paths`, which checks that [`nix-fallback-paths.nix`](../../../../nixos/modules/installer/tools/nix-fallback-paths.nix) matches its version.
- `nixVersions.git`: a snapshot of the Nix `master` branch.

Dropped series are replaced with a `throw` in the alias section at the bottom of [`default.nix`](./default.nix).

## Patch releases and `latest`/`git` updates

Branch to merge into: **master**, then backport to **release-$nixos-version** if that release ships the series.

The update script bumps every `nix_2_X` to its newest patch release, refreshes the fallback paths for `stable`, and updates `git`, making one commit for each:

```
./pkgs/tools/package-management/nix/update-all.sh
```

If you update by hand and the series is `stable`, refresh the fallback paths as well:

```
# Replace $version with the full Nix version, e.g. 2.35.6
curl https://releases.nixos.org/nix/nix-$version/fallback-paths.nix > nixos/modules/installer/tools/nix-fallback-paths.nix
```

Then follow [Testing](#testing).

## Bumping `nixVersions.stable` to a new release series

Branch to merge into: **master** as NixOS tests [no longer](https://github.com/NixOS/nixpkgs/pull/553728) depend on Nix by default.
If the bump lands close to a NixOS branch-off, coordinate with the release managers first.

1. Point `stable` at the new series in [`default.nix`](./default.nix), and refresh the fallback paths as described above in the same commit.
2. Check the consumers that pin a series (`rg 'nixVersions\.(nix|nixComponents)_2_'`).
   They are pinned for API compatibility and do not have to move with `stable`, but the old series has to stay until they do.
3. Consider a highlight in the NixOS release notes linking to the upstream release notes.
4. Follow [Testing](#testing), including the extra NixOS tests for `stable`.

## Testing

Build and test on **x86_64-linux**, **aarch64-linux** and **aarch64-darwin**.
If you lack the hardware, ask others for help, or request access to the Nix community builders [here](https://github.com/NixOS/aarch64-build-box) and [here](https://nix-community.org/community-builder/).

Build the packages that depend on the changed attributes:

```
nixpkgs-review pr <your-pull-request>
```

Run the package's own tests:

```
# Replace $version with the release series, e.g. 2_35
nix-build -A nixVersions.nix_$version.tests
```

On Linux, `misc`, `upgrade` and `simpleUefiSystemdBoot` in that set are NixOS tests that always use `nixVersions.stable`, whichever series you build them from.

### Extra NixOS tests for `stable`

When `stable` changes, also run the NixOS tests that use it.
Besides the installer, these cover the experimental features that are widely used in practice (`flakes`, `nix-command`, `ca-derivations`, `auto-allocate-uids`, `local-overlay-store`) and remote stores:

```
nix-build --keep-going \
  -A nixosTests.installer.simple \
  -A nixosTests.installer.simpleUefiGrub \
  -A nixosTests.installer.switchToFlake \
  -A nixos-rebuild-ng.tests.repl \
  -A nixosTests.nixos-rebuild-target-host \
  -A nixosTests.replace-dependencies \
  -A nixosTests.nix-daemon-unprivileged \
  -A nixosTests.nix-local-store \
  -A nixosTests.nix-serve-ssh \
  -A nixosTests.nar-serve \
  -A nixosTests.binary-cache \
  -A nixosTests.binary-cache-xz \
  -A nixosTests.binary-cache-no-compression
```
