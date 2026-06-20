{
  callPackage,
  fetchFromGitHub,
  lib,
}:

let
  version = "0.8.1";
  src = fetchFromGitHub {
    owner = "liamw1";
    repo = "oxibooru";
    tag = version;
    hash = "sha256-rKgSCXpVanIrihAYT3R6Gt7ajK9DTq8qfLnBqvnCgHo=";
  };
in

lib.recurseIntoAttrs rec {
  client = callPackage ./client.nix { inherit src version; };
  server = callPackage ./server.nix { inherit src version; };
  inherit (server) tests;
}
