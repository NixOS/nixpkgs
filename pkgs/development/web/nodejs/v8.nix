{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.11.3";
    sha256 = "1q3fc791ng1sgk0i5qnxpxri7235nkjm50zx1z34c759vhgpaz2p";
  }
