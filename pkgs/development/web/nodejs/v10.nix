{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.13.0";
    sha256 = "0hg6z89lczjs4cc8ljqqdy4h1n5ccwclniyyj2651yr81imck04d";
  }
