{
  callPackage,
  lib,
}:

# All versions are taken from `version.json` created by `update.py`, and realised with `generic.nix`.
# The `update.py` is a web scraper script that writes the latest versions into `version.json`.

# The `versions.json` can be automatically updated and committed with a commit summary.
# To do so, change directory to nixpkgs root, and do:
# $ nix-shell ./maintainers/scripts/update.nix --argstr package optifinePackages.optifine-latest --argstr commit true

lib.recurseIntoAttrs (
  lib.mapAttrs (name: value: callPackage ./generic.nix value) (lib.importJSON ./versions.json)
)
