{ callPackage, openssl, icu, python2, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { 
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.16.3";
    sha256 = "18srfcv9zi39960szdnd4rgfj9w295z1agjvpw8arwn75449nmgh";
  }
