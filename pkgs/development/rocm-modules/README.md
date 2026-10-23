# Rocmpackages version split

To introduce `rocmPackages_10` as part of https://github.com/NixOS/nixpkgs/issues/563157 existing code in `pkgs/development/rocm-modules/` is duplicated
into `pkgs/development/rocm-modules/7` and `pkgs/development/rocm-modules/10`. All code in `7` remains unchanged from the `7.2.4` release.
The new code in `10` starts as a duplicate of `7` to work around github's generally poor support for rename/move in PR's. There is
one exeception: to start `pkgs/development/rocm-modules/10/default.nix` is emptied of contents so `7.2.4` packages cannot be accidentally
built via the toplevel `rocmPackages_10` reference.

# Local build notes

When building locally setting `clr.localGpuTargets` generally results in significant reductions in code generation and build time.
See [Using ROCm with NixOS or Nixpkgs](https://lunnova.dev/articles/nixos-nixpkgs-rocm-usage)

# Local testing

`rocm-tests` contains a few general purpose tests to check `rocmPackages` and some consumers. In particular `rocmPackagesDerivations` is a
simple way to build the entire scope. They can be built like this:

```shell
nix-build <nixpkgs-src-root> --no-out-link -A pkgs.pkgsRocm.rocmPackages.rocm-tests.passthru.tests.rocmPackagesDerivations
```

# Updates

Bulk updates can be triggered by using:

```shell
nix-shell <nixpkgs-src-root> maintainers/scripts/update.nix --argstr team rocm  --arg keep-going true --argstr max-workers 4
```
