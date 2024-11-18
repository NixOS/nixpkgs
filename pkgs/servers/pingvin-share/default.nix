{
  callPackage,
  fetchFromGitHub,
  recurseIntoAttrs,
}:

let
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "stonith404";
    repo = "pingvin-share";
    rev = "v${version}";
    hash = "sha256-5tu81kB9UDui2/n5KJLRug4IHeDihuv8+HWeo0saqAM=";
  };
in

recurseIntoAttrs {
  backend = callPackage ./backend.nix { inherit src version; };

  frontend = callPackage ./frontend.nix { inherit src version; };
}
