{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.9.3";
    sha256 = "1nmjwsdql92jh6y94jpqa8cmirw6cl3cvaiqdsjyd1bbm8xxp3bl";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  }
