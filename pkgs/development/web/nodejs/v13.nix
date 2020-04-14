{ callPackage, openssl, icu, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { 
    inherit openssl icu;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "13.12.0";
    sha256 = "199qcvzikdzw0h25v9dws77fff6hbvr8dj50lyzlnkya1dd6fzhd";
  }
