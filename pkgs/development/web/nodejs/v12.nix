{ callPackage, icu68, python2, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    icu = icu68;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.22.8";
    sha256 = "0g0ihjzbd02izhmb4jzkdsr5788982wy8q2b4a1h04q8l4fwp197";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
