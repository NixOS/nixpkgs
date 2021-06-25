{ callPackage, icu68, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.1";
    sha256 = "12drpkffn79xx84pffg9y2cn9fiwycgaa2rjj3ix6visfzvhsrfx";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
