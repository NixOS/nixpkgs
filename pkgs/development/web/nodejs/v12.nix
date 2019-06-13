{ stdenv, callPackage, lib, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.4.0";
    sha256 = "1qwcv8m1m3293vmb4x2xrpqlpaa1r1951gf0mva60b2hsdk27d90";
  }
