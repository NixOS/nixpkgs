{
  callPackage,
  fetchFromGitHub,
  lib,
}:

let
  version = "2.5-unstable-2026-07-25";
  src = fetchFromGitHub {
    owner = "rr-";
    repo = "szurubooru";
    rev = "10ac8509ff73d539360215f65b95ad704e6a2740";
    hash = "sha256-7uvhB1kaRUpPr2qWcoVNXtOzK218w8SY3AsCPF0HeF4=";
  };
in

lib.recurseIntoAttrs rec {
  client = callPackage ./client.nix { inherit src version; };
  server = callPackage ./server.nix { inherit src version; };
  inherit (server) tests;
}
