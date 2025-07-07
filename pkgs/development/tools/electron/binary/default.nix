{ lib, callPackage }:

let
  infoJson = lib.importJSON ./info.json;
  mkElectron = callPackage ./generic.nix { };
in
lib.mapAttrs' (
  majorVersion: info:
  lib.nameValuePair "electron_${majorVersion}-bin" (mkElectron info.version info.hashes)
) infoJson
