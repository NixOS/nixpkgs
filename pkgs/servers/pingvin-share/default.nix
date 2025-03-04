{
  callPackage,
  fetchFromGitHub,
  recurseIntoAttrs,
}:

let
  version = "1.9.1";
  src = fetchFromGitHub {
    owner = "stonith404";
    repo = "pingvin-share";
    rev = "v${version}";
    hash = "sha256-Yy1Ncqgl5A/0bQ9BAtOdQCCmYNL+AfShm1dDtEydO9c=";
  };
in

recurseIntoAttrs {
  backend = callPackage ./backend.nix { inherit src version; };

  frontend = callPackage ./frontend.nix { inherit src version; };
}
