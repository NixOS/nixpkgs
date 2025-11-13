{
  lib,
  config,
  newScope,
}:
lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    dark-days-ahead = {
      tiles = callPackage ./dda/stable.nix { };

      curses = self.darkDaysAhead.tiles.override { tiles = false; };
    };

    dark-days-ahead-unstable = {
      tiles = callPackage ./dda/git.nix { };

      curses = self.darkDaysAheadUnstable.tiles.override { tiles = false; };
    };

    pkgs = callPackage ./pkgs { };

    buildMod = callPackage ./builder.nix {
      type = "mod";
    };
    buildSoundPack = callPackage ./builder.nix {
      type = "soundpack";
    };

    buildTileSet = callPackage ./builder.nix {
      type = "tileset";
    };
    wrapCDDA = callPackage ./wrapper.nix { };

    # Required to fix `pkgs` and `withMods` attrs after applying `overrideAttrs`.
    #
    # Example:
    #     let
    #       myBuild = cataclysmDDA.jenkins.latest.tiles.overrideAttrs (_: {
    #         x = "hello";
    #       });
    #
    #       # This refers to the derivation before overriding! So, `badExample.x` is not accessible.
    #       badExample = myBuild.withMods (_: []);
    #
    #       # `myBuild` is correctly referred by `withMods` and `goodExample.x` is accessible.
    #       goodExample = let
    #         inherit (cataclysmDDA) attachPkgs pkgs;
    #       in
    #       (attachPkgs pkgs myBuild).withMods (_: []);
    #     in
    #     goodExample.x  # returns "hello"
    attachPkgs =
      pkgs: super:
      let
        new = super.overrideAttrs (old: {
          passthru = old.passthru // {
            pkgs = pkgs.override { build = new; };
            withMods = self.wrapCDDA new;
          };
        });
      in
      new;
  }
  // lib.optionalAttrs config.allowAliases {
    stable = lib.mapAttrs (
      _: lib.warn "'cataclysm.stable' has been renamed to 'cataclysm.dark-days-ahead'"
    ) self.dark-days-ahead;
    git = lib.mapAttrs (
      _: lib.warn "'cataclysm.git' has been renamed to 'cataclysm.dark-days-ahead-unstable'"
    ) self.dark-days-ahead-unstable;
  }
)
