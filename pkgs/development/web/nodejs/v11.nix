{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "11.11.0";
    sha256 = "1732jv95xza8813wk7qy22jxh2x9lnc9lr0rqkql7ggf03wymn56";
  }
