{ callPackage, openssl, icu, python2, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { 
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.17.0";
    sha256 = "0csfdwzn1qssmkanxa8m3znjcc6h5qjaw934mkq9bz7zly39wvfa";
  }
