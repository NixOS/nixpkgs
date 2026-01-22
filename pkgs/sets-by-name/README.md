# Package sets

All folders here have to contain a `packageset.nix` which will will be autocalled as a package set
with `recurseIntoAttrs (callPackage sets/<name>/packageset.nix {})`.

Each package set has to be sorted by-name maybe sharded.

TODO
