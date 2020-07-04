{ callPackage, openssl, icu, python2, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { 
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.21.0";
    sha256 = "0fxpvjm3gyfwapn55av8q9w1ds0l4nmn6ybdlslcmjiqhfi1zc16";
  }
