{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "15.5.1";
    sha256 = "0qbb4dwgsy1a82ihjxl6r8bj7mwjzb21s720y1rahisd5p69l8ic";
  }
