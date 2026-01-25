# Package sets

All folders here containing a `packageset.nix` will be autocalled as a package set with `recurseIntoAttrs (callPackage sets/<name>/packageset.nix {})`, however since package sets often depend on some other package version, this directory stucture is relatively loose.

Calling package sets that cannot be autocalled should be done in [`pkgs/top-level/packagesets.nix`](../top-level/packagesets.nix).
