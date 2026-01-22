self: super:
let
  # Because of Nix's import-value cache, importing lib is free
  lib = import ../../lib;

  inherit (self)
    config
    ;
in

# autocalled sets
lib.pipe ../sets [
  builtins.readDir
  # filter out non directories like README.md
  (lib.filterAttrs (_: value: value == "directory"))

  # filter out manually called package sets
  (lib.filterAttrs (name: _: !(lib.pathExists ../sets/${name}/packageset.nix)))

  # autocall
  (lib.mapAttrs (
    name: _:
    lib.pipe (self: { }) [
      # overlay all autocalled by-name packages
      (lib.extends (
        self: super:
        lib.optionalAttrs (lib.pathExists ../sets/${name}/by-name) (
          import ./by-name-overlay.nix ../sets/${name}/by-name self super
        )
      ))

      # overlay aliases
      (lib.extends (
        self: super:
        lib.optionalAttrs config.allowAliases (
          import ../sets/${name}/aliases.nix self super # wrap!
        )
      ))

      # overlay functions
      (lib.extends (import ../sets/${name}/functions.nix))

      # overlay manual packages
      (lib.extends (import ../sets/${name}/manual-packages.nix))

      # overlay overrides
      (lib.extends (import ../sets/${name}/overrides.nix))

      # make a new scope and recurse into it
      (lib.makeScope self.newScope)
      lib.recurseIntoAttrs
    ]
  ))
]

# manually called sets
// {

}
