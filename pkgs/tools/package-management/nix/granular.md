# Nix granular build

Nix >=2.26 are built with Meson in a granular manner, with a derivation per component (per library, etc)
- Dependents only depend on what they need (e.g. Nix CLI users don't need the C API)
- Matches upstream, improving predictability, and reducing maintenance

`pkgs/tools/package-management/nix/<version>` contains Nix expressions that are copied from the Nixpkgs repository, for valid performance reasons (no IFD).
Their directory structure is preserved so that the upstream files can be used verbatim.

All path expressions (`./.`, `./data` etc) are consumed through functions that are implemented differently here vs upstream.
Our implementation here treats all path values as "virtual" paths, so it is ok that they don't point to real locations.
