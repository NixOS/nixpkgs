{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.1.0";
    sha256 = "1efb792c689fed2e028025e1398e84193281f329427a17a62b0bffee8e771395";
  }
