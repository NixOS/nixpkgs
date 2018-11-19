{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "11.2.0";
    sha256 = "19lz6wa35ysf0mjcb1rpi858995s1g698kpygfzvygp641py4kim";
  }
