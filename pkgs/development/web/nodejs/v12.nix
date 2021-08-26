{ callPackage, icu68, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.5";
    sha256 = "057xhxk440pxlgqpblsh4vfwmfzy0fx1h6q3jr2j79y559ngy9zr";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
