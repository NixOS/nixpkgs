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

      # overlay functions
      (lib.extends (
        self: super:
        let
          res = import ../sets/${name}/functions.nix self super;
          conflictingAttrs = lib.intersectAttrs res super;
        in
        assert lib.assertMsg (conflictingAttrs == { }) (
          "The following attributes were defined both in `pkgs/sets/${name}/functions.nix` and elsewhere, "
          + "most likely in `pkgs/sets/${name}/by-name/`: "
          + (lib.concatStringsSep ", " (lib.attrNames conflictingAttrs))
        );
        res
      ))

      # overlay manual packages
      (lib.extends (
        self: super:
        let
          res = import ../sets/${name}/manual-packages.nix self super;
          conflictingAttrs = builtins.intersectAttrs res super;
        in
        assert lib.assertMsg (conflictingAttrs == { }) (
          "The following attributes were defined both in `pkgs/sets/${name}/manual-packages.nix` and elsewhere, "
          + "most likely in `pkgs/sets/${name}/by-name/` or `pkgs/sets/${name}/functions.nix`: "
          + (lib.concatStringsSep ", " (lib.attrNames conflictingAttrs))
        );
        res
      ))

      # overlay aliases
      (lib.extends (
        self: super:
        let
          res = import ../sets/${name}/aliases.nix self super;
          conflictingAttrs = builtins.intersectAttrs res super;
        in
        assert lib.assertMsg (conflictingAttrs == { }) (
          "The following attributes were defined both in `pkgs/sets/${name}/aliases.nix` and elsewhere, "
          + "most likely in `pkgs/sets/${name}/by-name/`, `pkgs/sets/${name}/functions.nix` or `pkgs/sets/${name}/manual-packages.nix`: "
          + (lib.concatStringsSep ", " (lib.attrNames conflictingAttrs))
        );
        (lib.optionalAttrs config.allowAliases res)
      ))

      # make a new scope and recurse into it
      (lib.makeScope self.newScope)
      lib.recurseIntoAttrs
    ]
  ))
]

# manually called sets
// {
  # python
  # we only recurse into the newest 2 python versions
  python3PackagesFor = self.callPackage ../sets/python3Packages/packageset.nix { };
  python311Packages = self.python311.pkgs;
  python312Packages = self.python312.pkgs;
  python313Packages = lib.recurseIntoAttrs (self.python313.pkgs);
  python314Packages = lib.recurseIntoAttrs (self.python314.pkgs);
  python315Packages = self.python315.pkgs;
  python316Packages = self.python316.pkgs;
  python3Packages = self.python314Packages;
  pypy310Packages = self.pypy310.pkgs;
  pypy311Packages = self.pypy311.pkgs;
  pypy3Packages = self.pypy3.pkgs;
}
