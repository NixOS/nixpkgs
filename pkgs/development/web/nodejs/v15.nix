{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "15.7.0";
    sha256 = "1nnv5337p23mhp0s2zgv75yysgfai0px8h1kks2mc8w0xnmwwppg";
  }
