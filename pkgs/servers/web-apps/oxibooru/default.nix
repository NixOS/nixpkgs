{
  callPackage,
  fetchFromGitHub,
  lib,
}:

let
  version = "0.9.0";
  src = fetchFromGitHub {
    owner = "liamw1";
    repo = "oxibooru";
    tag = version;
    hash = "sha256-OO+wAbS7IEtNNA7gorSBSQYPjzbxMfNTxcupnzdglRU=";
  };
in

lib.recurseIntoAttrs {
  client = callPackage ./client.nix { inherit src version; };
  server = callPackage ./server.nix { inherit src version; };
}
