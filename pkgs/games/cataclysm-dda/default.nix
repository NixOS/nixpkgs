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
    dark-days-ahead =
      self.attachPkgs self.pkgs (callPackage ./dda/stable.nix { })
      // (lib.optionalAttrs config.allowAliases {
        tiles = lib.warnOnInstantiate "'cataclysm.dark-days-ahead.tiles' is now accessed with the helper 'cataclysm.dark-days-ahead.withTiles'" self.dark-days-ahead.withTiles;
        curses = lib.warnOnInstantiate "'cataclysm.dark-days-ahead.curses ' is now named 'cataclysm.dark-days-ahead'" self.dark-days-ahead;
      });

    dark-days-ahead-unstable =
      self.attachPkgs self.pkgs (callPackage ./dda/git.nix { })
      // (lib.optionalAttrs config.allowAliases {
        tiles = lib.warnOnInstantiate "'cataclysm.dark-days-ahead-unstable.tiles' is now accessed with the helper 'cataclysm.dark-days-ahead-unstable.withTiles'" self.dark-days-ahead-unstable.withTiles;
        curses = lib.warnOnInstantiate "'cataclysm.dark-days-ahead-unstable.curses ' is now named 'cataclysm.dark-days-ahead-unstable'" self.dark-days-ahead-unstable;
      });

    mkCataclysm = callPackage ./mkCataclysm.nix { };
    pkgs = callPackage ./pkgs { };

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
    buildMod = lib.warn "'cataclysm.buildMod' has been moved to 'cataclysm.pkgs.buildMod'" self.pkgs.buildMod;
    buildSoundPack = lib.warn "'cataclysm.buildSoundPack' has been moved to 'cataclysm.pkgs.buildSoundPack'" self.pkgs.buildSoundPack;
    buildTileSet = lib.warn "'cataclysm.buildTileSet' has been moved to 'cataclysm.pkgs.buildTileSet'" self.pkgs.buildTileSet;
    stable = lib.mapAttrs (
      _: lib.warn "'cataclysm.stable' has been renamed to 'cataclysm.dark-days-ahead'"
    ) self.dark-days-ahead;
    git = lib.mapAttrs (
      _: lib.warn "'cataclysm.git' has been renamed to 'cataclysm.dark-days-ahead-unstable'"
    ) self.dark-days-ahead-unstable;
  }
)
