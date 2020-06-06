{ callPackage, openssl, icu, python2, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { 
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.18.0";
    sha256 = "0gxi0cxkiylxr4spm3vg6n9w3x82770xaazhax8pydkqlcv8cs6l";
  }
