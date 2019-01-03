{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "11.6.0";
    sha256 = "1czrpxmk6calqn0p92rm0bv2vlgbnx6q4z7n2j8r7aw0khwbxwll";
  }
