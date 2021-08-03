{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.6.0";
    sha256 = "1ndrqx3k5m62r7nzl5za59m33bx10541n7xbaxxz7088ifh18msw";
  }
