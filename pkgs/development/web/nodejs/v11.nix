{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "11.15.0";
    sha256 = "68a776c5d8b8b91a8f2adac2ca4ce4390ae1804883ec7ec9c0d6a6a64d306a76";
  }
