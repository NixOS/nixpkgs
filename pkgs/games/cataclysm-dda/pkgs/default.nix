{
  lib,
  newScope,
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

    mod = { };

    soundpack = { };

    tileset = {
      UndeadPeople = callPackage ./tilesets/UndeadPeople { };
    };
  }
)
