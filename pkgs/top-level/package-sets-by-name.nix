self: super:
let
  # Because of Nix's import-value cache, importing lib is free
  lib = import ../../lib;
in
lib.pipe ../sets-by-name [
  builtins.readDir
  # filter out non directories like README.md
  (lib.filterAttrs (_: value: value == "directory"))
  (lib.mapAttrs (
    name: _:
    lib.pipe (self: { }) [
      # autocall all sharded by name packages
      (lib.extends (import ./by-name-overlay.nix ../sets-by-name/${name}))
      # overlay aliases
      (lib.extends (
        self: super:
        lib.optionalAttrs self.config.allowAliases (import (../sets-by-name/${name}/aliases.nix) self super)
      ))
      # overlay functions
      (lib.extends (import (../sets-by-name/${name}/functions.nix)))
      # overlay overrides
      (lib.extends (import (../sets-by-name/${name}/overrides.nix)))
      # make a new scope and recurse into it
      (lib.makeScope self.newScope)
      lib.recurseIntoAttrs
    ]
  ))
]
