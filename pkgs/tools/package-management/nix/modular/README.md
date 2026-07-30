# `nix/modular`

This directory follows a directory structure similar to that in the upstream repo,
to make comparisons easier.

The files are maintained separately from the upstream repo, so differences are expected.

## Comparison

### No filesets

Using filesets with a fetched source would require "IFD", as the fetching happens in a derivation, but the filtering must come afterwards, and be done by the evaluator.

### `workDir` attribute

The Nixpkgs for Nix inherits the `workDir` attribute that determines the location of the subproject to build.
It is compared to this directory to produce the correct relative path, similar to upstream.
