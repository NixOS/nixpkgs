{ newScope }:

let
  callPackage = newScope self;

  stable = rec {
    tiles = callPackage ./stable.nix { };

    curses = tiles.override { tiles = false; };
  };

  git = rec {
    tiles = callPackage ./git.nix { };

    curses = tiles.override { tiles = false; };
  };

  lib = callPackage ./lib.nix { };

  pkgs = callPackage ./pkgs { };

  self = {
    inherit
      callPackage
      stable
      git
      ;

    inherit (lib)
      buildMod
      buildSoundPack
      buildTileSet
      wrapCDDA
      attachPkgs
      ;

    inherit pkgs;
  };
in

self
