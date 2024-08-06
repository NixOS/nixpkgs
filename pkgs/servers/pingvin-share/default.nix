{
  callPackage,
  fetchFromGitHub,
  recurseIntoAttrs,
}:

let
  version = "0.29.0";
  src = fetchFromGitHub {
    owner = "stonith404";
    repo = "pingvin-share";
    rev = "v${version}";
    hash = "sha256-ETsIGb6IxGruApUP05cuMtTDNAE23CI1Q2MmjxX3aPo=";
  };
in

recurseIntoAttrs {
  backend = callPackage ./backend.nix { inherit src version; };

  frontend = callPackage ./frontend.nix { inherit src version; };
}
