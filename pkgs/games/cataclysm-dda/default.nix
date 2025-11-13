{ lib, newScope }:
lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    stable = {
      tiles = callPackage ./dda/stable.nix { };

      curses = self.stable.tiles.override { tiles = false; };
    };

    git = {
      tiles = callPackage ./dda/git.nix { };

      curses = self.git.tiles.override { tiles = false; };
    };

    inherit (callPackage ./lib.nix { })
      buildMod
      buildSoundPack
      buildTileSet
      wrapCDDA
      attachPkgs
      ;
    pkgs = callPackage ./pkgs { };
  }
)
