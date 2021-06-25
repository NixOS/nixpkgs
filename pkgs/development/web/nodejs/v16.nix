{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.4.0";
    sha256 = "07f8g3hs0v7nsdvzlsr1p4pzgb04qn54pnhmbdsgmmb41cp227pr";
  }
