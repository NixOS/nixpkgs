{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.14.0";
    sha256 = "1rphkl3lqg0rzgg0r58bfv1hjw3rg96qvqcilk2927kbpps3bs84";
  }
