{
  callPackage,
  fetchFromGitHub,
  recurseIntoAttrs,
}:

let
  version = "1.10.2";
  src = fetchFromGitHub {
    owner = "stonith404";
    repo = "pingvin-share";
    rev = "v${version}";
    hash = "sha256-xP6XiehTbbXu9hCxF1mwb9ud/2SCnaskhz9XMtF3HKI=";
  };
in

recurseIntoAttrs {
  backend = callPackage ./backend.nix { inherit src version; };

  frontend = callPackage ./frontend.nix { inherit src version; };
}
