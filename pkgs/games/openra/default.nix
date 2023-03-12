{ lib, callPackage }:

with lib;

let
  buildOpenRAEngine = callPackage ./build-engine.nix {};
in
{
  engines = {
    release = buildOpenRAEngine (callPackage ./engines/release {});
  };
}
