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
    # Main game
    dark-days-ahead =
      (callPackage ./dda/stable.nix { })
      // (lib.optionalAttrs config.allowAliases {
        tiles = lib.warnOnInstantiate "'cataclysm.dark-days-ahead.tiles' is now accessed with the helper 'cataclysm.dark-days-ahead.withTiles'" self.dark-days-ahead.withTiles;
        curses = lib.warnOnInstantiate "'cataclysm.dark-days-ahead.curses ' is now named 'cataclysm.dark-days-ahead'" self.dark-days-ahead;
      });

    dark-days-ahead-unstable =
      (callPackage ./dda/git.nix { })
      // (lib.optionalAttrs config.allowAliases {
        tiles = lib.warnOnInstantiate "'cataclysm.dark-days-ahead-unstable.tiles' is now accessed with the helper 'cataclysm.dark-days-ahead-unstable.withTiles'" self.dark-days-ahead-unstable.withTiles;
        curses = lib.warnOnInstantiate "'cataclysm.dark-days-ahead-unstable.curses ' is now named 'cataclysm.dark-days-ahead-unstable'" self.dark-days-ahead-unstable;
      });

    # Forks
    bright-nights = callPackage ./bn { };
    the-last-generation = callPackage ./tlg { };

    # Utilities
    mkCataclysm = callPackage ./mkCataclysm.nix { };
    wrapCDDA = _: throw "'cataclysm.wrapCDDA' should be accessed via 'cataclysm.$GAME.withMods'";
    pkgs = callPackage ./pkgs { };

    _tests = callPackage ./tests.nix { };
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
