{ callPackage, openssl, icu, python2, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.22.1";
    sha256 = "0pr569qiabr4m7k38s7rwi3iyzrc5jmx19z2z0k7n4xfvhjlfzzl";
    patches = stdenv.lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
