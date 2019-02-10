{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.15.1";
    sha256 = "0n68c4zjakdj6yzdc9fbrn0wghyslkya9sz1v6122i40zfwzfm8s";
  }
