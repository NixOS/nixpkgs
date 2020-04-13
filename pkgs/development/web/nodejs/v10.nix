{ callPackage, openssl, icu, python2, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { 
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.20.1";
    sha256 = "14pljmfr0dkj6y63j0qzj173kdpbbs4v1g4v56hyv2k09jh8h7zf";
  }
