{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "9.4.0";
    sha256 = "035j44xkji9dxddlqws6ykkbyphbkhwhz700arpgz20jz3qf20vm";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  }
