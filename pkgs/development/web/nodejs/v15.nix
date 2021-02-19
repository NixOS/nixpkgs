{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "15.9.0";
    sha256 = "1hyq6zj2z3kyfpa8znxa6jwzkw9bvb8mssalify2sjiv00f9dmxx";
  }
