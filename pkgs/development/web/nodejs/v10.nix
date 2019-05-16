{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.15.3";
    sha256 = "1mcijznh481s44i59p571a38bfvcxm9f8x2l0l1005aly0kdj8jf";
  }
