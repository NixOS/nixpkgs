{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "6.11.5";
    sha256 = "1bwakrvy0if5spbymwpb05qwrb47xwzlnc42rapgp6b744ay8v8w";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode.patch ];
  }
