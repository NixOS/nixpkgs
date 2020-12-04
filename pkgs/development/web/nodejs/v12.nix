{ callPackage, openssl, icu, python2, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.20.0";
    sha256 = "12s2vjrlhgap2r12s7rqf0r2wzh9q2r5dkh3ak9fhrgmk9fgvqv1";
    patches = stdenv.lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
