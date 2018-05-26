{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "9.11.1";
    sha256 = "0k4xkcymf4y3k2bxjryb2lj97bxnng75x7a77i2wgx94749kvp13";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  }
