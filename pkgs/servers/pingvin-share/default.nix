{
  callPackage,
  fetchFromGitHub,
  recurseIntoAttrs,
}:

let
  version = "1.7.0";
  src = fetchFromGitHub {
    owner = "stonith404";
    repo = "pingvin-share";
    rev = "v${version}";
    hash = "sha256-wZV3PKnGoD3g4PjSDPwMm4ftUTlEZykNkWlwLCDJfuM=";
  };
in

recurseIntoAttrs {
  backend = callPackage ./backend.nix { inherit src version; };

  frontend = callPackage ./frontend.nix { inherit src version; };
}
