{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.15.0";
    sha256 = "0cy6lzk9sn545kkc0jviv0k0hn30kindrpkkkmv3zk2774rj71cn";
  }
