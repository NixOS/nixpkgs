{
  callPackage,
  fetchFromGitHub,
  lib,
}:

let
  version = "0.7.6-unstable-2026-06-19";
  src = fetchFromGitHub {
    owner = "liamw1";
    repo = "oxibooru";
    rev = "1c63144552cb398a00c08568acf5bfbea95510d9";
    hash = "sha256-VS5OifDKF77f1bYvsXN3qpf1QOmEwR+ZZ2Gc8R1ueOU=";
  };
in

lib.recurseIntoAttrs {
  client = callPackage ./client.nix { inherit src version; };
  server = callPackage ./server.nix { inherit src version; };
}
