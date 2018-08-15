{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.7.0";
    sha256 = "0qp93ddbnvadimj11wnznwhkq8vq1f7q259iq8siy5b7r936kvil";
  }
