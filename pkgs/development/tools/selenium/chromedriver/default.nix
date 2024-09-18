{ lib, stdenv, chromium, callPackage }:
if lib.meta.availableOn stdenv.hostPlatform chromium
  then callPackage ./source.nix {}
  else callPackage ./binary.nix {}
