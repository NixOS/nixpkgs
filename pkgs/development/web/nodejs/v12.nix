{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.2.0";
    sha256 = "10vr8yqrvdmcaszg7l7cjchzzik709vcygcnpkjf2sjhz929glf5";
  }
