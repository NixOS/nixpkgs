{ callPackage, openssl, icu, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.23.3";
    sha256 = "13za06bz17k71gcxyrx41l2j8al1kr3j627b8m7kqrf3l7rdfnsi";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
