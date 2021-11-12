{ callPackage, icu68, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.7";
    sha256 = "0sszg3k5jd26hymqhs5328kvnxsb3x78sg4gpna9lrvh92s26snc";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
