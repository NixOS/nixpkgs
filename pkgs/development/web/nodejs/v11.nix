{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "11.5.0";
    sha256 = "07fdpl8wzkcdd8iyaiwf2ah1rgishk2hrl0g73i8aggwplrl69fx";
  }
