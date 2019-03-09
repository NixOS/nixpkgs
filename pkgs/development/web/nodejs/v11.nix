{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "11.7.0";
    sha256 = "18md1xz055rxds4i831rmmya0xda7cc0wdmr1jnj8vigfbcbvzh7";
  }
