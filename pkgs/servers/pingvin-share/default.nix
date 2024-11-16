{
  callPackage,
  fetchFromGitHub,
  recurseIntoAttrs,
}:

let
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "stonith404";
    repo = "pingvin-share";
    rev = "v${version}";
    hash = "sha256-OCAuntdOdIQ3hFOoSQxoPzNSg1mz1qrNhtayXZ0Hl8o=";
  };
in

recurseIntoAttrs {
  backend = callPackage ./backend.nix { inherit src version; };

  frontend = callPackage ./frontend.nix { inherit src version; };
}
