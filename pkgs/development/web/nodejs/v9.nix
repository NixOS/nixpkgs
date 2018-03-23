{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "9.8.0";
    sha256 = "1b0ynhvnq25w29rmshim0dn4m1dknkn1p52idi6acpzswi4vn1h7";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  }
