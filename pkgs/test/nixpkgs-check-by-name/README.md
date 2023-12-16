# Nixpkgs pkgs/by-name checker

This directory implements a program to check the [validity](#validity-checks) of the `pkgs/by-name` Nixpkgs directory.
It is being used by [this GitHub Actions workflow](../../../.github/workflows/check-by-name.yml).
This is part of the implementation of [RFC 140](https://github.com/NixOS/rfcs/pull/140).

## Interface

The interface of the tool is shown with `--help`:
```
cargo run -- --help
```

The interface may be changed over time only if the CI workflow making use of it is adjusted to deal with the change appropriately.

## Validity checks

These checks are performed by this tool:

### File structure checks
- `pkgs/by-name` must only contain subdirectories of the form `${shard}/${name}`, called _package directories_.
- The `name`'s of package directories must be unique when lowercased.
- `name` is a string only consisting of the ASCII characters `a-z`, `A-Z`, `0-9`, `-` or `_`.
- `shard` is the lowercased first two letters of `name`, expressed in Nix: `shard = toLower (substring 0 2 name)`.
- Each package directory must contain a `package.nix` file and may contain arbitrary other files.

### Nix parser checks
- Each package directory must not refer to files outside itself using symlinks or Nix path expressions.

### Nix evaluation checks
- For each package directory, the `pkgs.${name}` attribute must be defined as `callPackage pkgs/by-name/${shard}/${name}/package.nix args` for some `args`.
- For each package directory, `pkgs.lib.isDerivation pkgs.${name}` must be `true`.

### Ratchet checks

Furthermore, this tool implements certain [ratchet](https://qntm.org/ratchet) checks.
This allows gradually phasing out deprecated patterns without breaking the base branch or having to migrate it all at once.
It works by not allowing new instances of the pattern to be introduced, but allowing already existing instances.
The existing instances are coming from `<BASE_NIXPKGS>`, which is then checked against `<NIXPKGS>` for new instances.
Ratchets should be removed eventually once the pattern is not used anymore.

The current ratchets are:

- New manual definitions of `pkgs.${name}` (e.g. in `pkgs/top-level/all-packages.nix`) with `args = { }`
  (see [nix evaluation checks](#nix-evaluation-checks)) must not be introduced.

## Development

Enter the development environment in this directory either automatically with `direnv` or with
```
nix-shell
```

Then use `cargo`:
```
cargo build
cargo test
cargo fmt
cargo clippy
```

## Tests

Tests are declared in [`./tests`](./tests) as subdirectories imitating Nixpkgs with these files:
- `default.nix`:
  Always contains
  ```nix
  import ../mock-nixpkgs.nix { root = ./.; }
  ```
  which makes
  ```
  nix-instantiate <subdir> --eval -A <attr> --arg overlays <overlays>
  ```
  work very similarly to the real Nixpkgs, just enough for the program to be able to test it.
- `pkgs/by-name`:
  The `pkgs/by-name` directory to check.

- `all-packages.nix` (optional):
  Contains an overlay of the form
  ```nix
  self: super: {
    # ...
  }
  ```
  allowing the simulation of package overrides to the real [`pkgs/top-level/all-packages.nix`](../../top-level/all-packages.nix`).
  The default is an empty overlay.

- `base` (optional):
  Contains another subdirectory imitating Nixpkgs with potentially any of the above structures.
  This is used for [ratchet checks](#ratchet-checks).

- `expected` (optional):
  A file containing the expected standard output.
  The default is expecting an empty standard output.

## Hydra builds

This program will always be available pre-built for `x86_64-linux` on the `nixos-unstable` channel and `nixos-XX.YY` channels.
This is ensured by including it in the `tested` jobset description in [`nixos/release-combined.nix`](../../../nixos/release-combined.nix).

This allows CI for PRs to development branches `master` and `release-XX.YY` to fetch the pre-built program from the corresponding channel and use that to check the PR. This has the following benefits:
- It allows CI to check all PRs, even if they would break the CI tooling.
- It makes the CI check very fast, since no Nix builds need to be done, even for mass rebuilds.
- It improves security, since we don't have to build potentially untrusted code from PRs.
  The tool only needs a very minimal Nix evaluation at runtime, which can work with [readonly-mode](https://nixos.org/manual/nix/stable/command-ref/opt-common.html#opt-readonly-mode) and [restrict-eval](https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-restrict-eval).
- It allows anybody to make updates to the tooling and for those updates to be automatically used by CI without needing a separate release mechanism.

The tradeoff is that there's a delay between updates to the tool and those updates being used by CI.
This needs to be considered when updating the [API](#api).
