{ callPackage, icu68, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.9";
    sha256 = "0jp2fdl73zj5lqjvw98i8pcf7m05cvjcab231zjvdhl4wl1jr66s";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
