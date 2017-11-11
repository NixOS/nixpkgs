{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "4.8.5";
    sha256 = "0lqdnnihmc2wpl1v1shj60i49wka2354b00a86k0xbjg5gyfx2m4";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode.patch ];
  }
