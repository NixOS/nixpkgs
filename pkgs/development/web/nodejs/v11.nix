{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "11.14.0";
    sha256 = "1rvdyvlvh8ddm9y2razshly5kb87kw0js287i0a5dzb5ay41vxlx";
  }
