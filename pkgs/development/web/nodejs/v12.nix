{ callPackage, openssl, icu, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.0";
    sha256 = "08xsc1pw6352v5lz92ppfhrcmqnbm6m5wmjfs9frz26lp875yp6z";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
