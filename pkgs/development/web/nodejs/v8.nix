{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.15.1";
    sha256 = "1ldd4p7cf7bjl4yg9d91khzd9662g3wda7g1yr0ljqjjyjiqcr3b";
  }
