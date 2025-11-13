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
      type = "mod";
    };
    buildSoundPack = callPackage ./mkAsset.nix {
      type = "soundpack";
    };

    buildTileSet = callPackage ./mkAsset.nix {
      type = "tileset";
    };

    mod = { };

    soundpack = { };

    tileset = {
      UndeadPeople = callPackage ./tilesets/UndeadPeople { };
    };
  }
)
