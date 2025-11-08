{
  lib,
  callPackage,
  fetchFromGitHub,
}:

let
  version = "1.13.0";
  src = fetchFromGitHub {
    owner = "stonith404";
    repo = "pingvin-share";
    rev = "v${version}";
    hash = "sha256-FWc0Yo2Phh8ee5izHj0ol1pwLSVJgIqyeaJo1o4drsM=";
  };
in

lib.recurseIntoAttrs {
  backend = callPackage ./backend.nix { inherit src version; };

  frontend = callPackage ./frontend.nix { inherit src version; };
}
