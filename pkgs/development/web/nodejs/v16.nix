{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.4.1";
    sha256 = "1a1aygksmbafxvrs8g2jv0y1jj3cwyclk0qbqxkn5qfq5r1i943n";
  }
