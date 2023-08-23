# Nixpkgs pkgs/by-name checker

This directory implements a program to check the [validity](#validity-checks) of the `pkgs/by-name` Nixpkgs directory once introduced.
This is part of the implementation of [RFC 140](https://github.com/NixOS/rfcs/pull/140).

## API

This API may be changed over time if the CI making use of it is adjusted to deal with the change appropriately.

- Command line: `nixpkgs-check-by-name <NIXPKGS>`
- Arguments:
  - `<NIXPKGS>`: The path to the Nixpkgs to check
- Exit code:
  - `0`: If the [validation](#validity-checks) is successful
  - `1`: If the [validation](#validity-checks) is not successful
  - `2`: If an unexpected I/O error occurs
- Standard error:
  - Informative messages
  - Error messages if validation is not successful

## Validity checks

These checks are performed by this tool:

### File structure checks
- `pkgs/by-name` must only contain subdirectories of the form `${shard}/${name}`, called _package directories_.
- The `name`'s of package directories must be unique when lowercased
- `name` is a string only consisting of the ASCII characters `a-z`, `A-Z`, `0-9`, `-` or `_`.
- `shard` is the lowercased first two letters of `name`, expressed in Nix: `shard = toLower (substring 0 2 name)`.
- Each package directory must contain a `package.nix` file and may contain arbitrary other files.

### Nix parser checks
- Each package directory must not refer to files outside itself using symlinks or Nix path expressions.

### Nix evaluation checks
- `pkgs.${name}` is defined as `callPackage pkgs/by-name/${shard}/${name}/package.nix args` for some `args`.
- `pkgs.lib.isDerivation pkgs.${name}` is `true`.

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

- `expected` (optional):
  A file containing the expected standard output.
  The default is expecting an empty standard output.
