{ lib, callPackage }:

let
  infoJson = lib.importJSON ./info.json;
  mkElectronChromedriver = callPackage ./generic.nix { };
in
lib.mapAttrs' (
  majorVersion: info:
  lib.nameValuePair "electron-chromedriver_${majorVersion}" (
    mkElectronChromedriver info.version info.hashes
  )
) infoJson
