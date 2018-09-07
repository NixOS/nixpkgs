{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.9.0";
    sha256 = "00hdachbmcf9pyd1iksprsi5mddwp6z59mb3lr81z8ynfbmzhzni";
  }
