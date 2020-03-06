{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "13.10.1";
    sha256 = "14pvqwhilq210zn830zmh04a62rj3si0ijc4ihrhdf3dvghrx2c3";
  }
