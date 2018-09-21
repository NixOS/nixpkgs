{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.11.0";
    sha256 = "16wfgwnb2yd6y608svj2fizdq3sid44m0wqn4swkvclxb71444mr";
  }
