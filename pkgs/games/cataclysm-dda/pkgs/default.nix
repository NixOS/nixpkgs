{
  lib,
  newScope,
  config,
  build ? null,
}:
lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    buildMod = callPackage ./mkAsset.nix {
      assetType = "mod";
    };
    buildSoundPack = callPackage ./mkAsset.nix {
      assetType = "soundpack";
    };

    buildTileSet = callPackage ./mkAsset.nix {
      assetType = "tileset";
    };

    mods = { };

    soundPacks = { };

    tileSets = {
      undead-people = callPackage ./tilesets/UndeadPeople { };
    }
    // lib.optionalAttrs config.allowAliases {
      UndeadPeople = lib.warnOnInstantiate "'cataclysm.pkgs.tileSets.UndeadPeople' has been renamed to 'cataclysm.pkgs.tileSets.undead-people'" self.tileSets.undead-people;
    };
  }
  // (lib.optionalAttrs config.allowAliases {
    mod = lib.mapAttrs (
      _: lib.warn "'cataclysm.pkgs.mod' has been renamed to 'cataclysm.pkgs.mods'"
    ) self.mods;
    soundpack = lib.mapAttrs (
      _: lib.warn "'cataclysm.pkgs.soundpack' has been renamed to 'cataclysm.pkgs.soundPacks'"
    ) self.soundPacks;
    tileset = lib.mapAttrs (
      _: lib.warn "'cataclysm.pkgs.tileset' has been renamed to 'cataclysm.pkgs.tileSets'"
    ) self.tileSets;
  })
)
