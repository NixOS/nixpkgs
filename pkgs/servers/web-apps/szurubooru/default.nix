{
  callPackage,
  fetchFromGitHub,
  recurseIntoAttrs,
}:

let
  version = "2.5-unstable-2025-02-11";
  src = fetchFromGitHub {
    owner = "rr-";
    repo = "szurubooru";
    rev = "376f687c386f65522b2f65e98b998b21af26ee29";
    hash = "sha256-4w1iOYp+CVg60dYxRilj08D4Hle6R9Y0v+Nd3fws1Zc=";
  };
in

recurseIntoAttrs {
  client = callPackage ./client.nix { inherit src version; };
  server = callPackage ./server.nix { inherit src version; };
}
