{
  callPackage,
  fetchFromGitHub,
  lib,
}:

let
  version = "2.5-unstable-2025-07-19";
  src = fetchFromGitHub {
    owner = "rr-";
    repo = "szurubooru";
    rev = "5a0f8867f3af1556d82c1ad7e29977903300c2dd";
    hash = "sha256-ihocmBS4h23bb4ZRhHEXvnHiNfRMPdUe94B5K9bi2E4=";
  };
in

lib.recurseIntoAttrs {
  client = callPackage ./client.nix { inherit src version; };
  server = callPackage ./server.nix { inherit src version; };
}
