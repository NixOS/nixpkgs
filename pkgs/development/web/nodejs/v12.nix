{ callPackage, openssl, icu, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.1";
    sha256 = "12drpkffn79xx84pffg9y2cn9fiwycgaa2rjj3ix6visfzvhsrfx";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
