{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "6.13.1";
    sha256 = "0ikasm20wq56gvn3j28hxjwbvqqzqj5w0p2sc3ss00v58w5kady4";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode.patch ./no-xcodebuild.patch ];
  }
