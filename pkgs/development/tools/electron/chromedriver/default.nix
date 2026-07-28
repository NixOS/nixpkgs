let
  infoJson = builtins.fromJSON (builtins.readFile ./info.json);
in

{ lib, callPackage }:

let
  mkElectronChromedriver = callPackage ./generic.nix { };
in
lib.mapAttrs' (
  majorVersion: info:
  lib.nameValuePair "electron-chromedriver_${majorVersion}" (
    mkElectronChromedriver info.version info.hashes
  )
) infoJson
