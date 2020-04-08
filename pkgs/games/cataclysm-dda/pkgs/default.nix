{ lib, callPackage, build ? null }:

let
  pkgs = {
    mod = {
    };

    soundpack = {
    };

    tileset = {
    };
  };

  availableForBuild = _: mod:
  if isNull build then
    true
  else if build.isTiles then
    mod.forTiles
  else
    mod.forCurses;
in

lib.mapAttrs (_: mod: lib.filterAttrs availableForBuild mod) pkgs
