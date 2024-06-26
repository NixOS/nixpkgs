{ lib, callPackage }:

let
  mkElectron = callPackage ./generic.nix { };
  infoJson = builtins.fromJSON (builtins.readFile ./info.json);
in
lib.mapAttrs' (
  majorVersion: info:
  lib.nameValuePair "electron_${majorVersion}-bin" (mkElectron info.version info.hashes)
) infoJson
