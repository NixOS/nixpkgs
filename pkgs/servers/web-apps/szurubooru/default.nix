{
  callPackage,
  fetchFromGitHub,
  lib,
}:

let
  version = "2.5-unstable-2026-05-26";
  src = fetchFromGitHub {
    owner = "rr-";
    repo = "szurubooru";
    rev = "22fd239e18c9bae650f23c7db02cad2bfd570daf";
    hash = "sha256-x74Y1BAcQFseWNSc046zZJtj1Iq3PIvNb9fW9CgNRQI=";
  };
in

lib.recurseIntoAttrs rec {
  client = callPackage ./client.nix { inherit src version; };
  server = callPackage ./server.nix { inherit src version; };
  inherit (server) tests;
}
