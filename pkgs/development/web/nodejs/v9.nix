{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "9.3.0";
    sha256 = "1kap1hi4am5advfp6yb3bd5nhd2wx2j72cjq8qqg7yh95xg0g25j";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  }
