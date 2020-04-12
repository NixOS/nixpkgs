{ callPackage, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.20.1";
    sha256 = "14pljmfr0dkj6y63j0qzj173kdpbbs4v1g4v56hyv2k09jh8h7zf";
  }
