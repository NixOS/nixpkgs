{ callPackage, openssl, icu, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.24.0";
    sha256 = "1k1srdis23782hnd1ymgczs78x9gqhv77v0am7yb54gqcspp70hm";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
