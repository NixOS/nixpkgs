{ callPackage, openssl, icu, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.21.0";
    sha256 = "17cp3sv6smpig5xq0z3xgnqdii6k8lm4n5d1nl9vasgmwsn3fbq5";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
