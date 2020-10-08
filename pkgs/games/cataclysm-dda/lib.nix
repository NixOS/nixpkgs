{ callPackage }:

{
  buildMod = callPackage ./builder.nix {
    type = "mod";
  };

  buildSoundPack = callPackage ./builder.nix {
    type = "soundpack";
  };

  buildTileSet = callPackage ./builder.nix {
    type = "tileset";
  };

  wrapCDDA = callPackage ./wrapper.nix {};
}
