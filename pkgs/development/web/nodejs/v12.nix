{ callPackage, openssl, icu, python2, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.19.1";
    sha256 = "0zdis5wd84c57qjdiry8mmhpp009wqhb51f67iphl06vqc67w1vl";
  }
