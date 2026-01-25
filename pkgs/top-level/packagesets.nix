self: super:
let
  # Because of Nix's import-value cache, importing lib is free
  lib = import ../../lib;
in
(lib.pipe ../sets [
  builtins.readDir
  (lib.filterAttrs (name: _: lib.pathIsRegularFile ../sets/${name}/packageset.nix))
  (builtins.mapAttrs (
    name: _: lib.recurseIntoAttrs (self.callPackage ../sets/${name}/packageset.nix { })
  ))
])
