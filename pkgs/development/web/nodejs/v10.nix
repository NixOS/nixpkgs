{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.15.0";
    sha256 = "0gnygq4n7aar4jrynnnslxhlrlrml9f1n9passvj2fxqfi6b6ykr";
  }
