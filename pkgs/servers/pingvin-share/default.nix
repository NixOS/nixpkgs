{ callPackage
, fetchFromGitHub
, recurseIntoAttrs
, nixosTests
}:

let
  version = "0.22.2";
  src = fetchFromGitHub {
    owner = "stonith404";
    repo = "pingvin-share";
    rev = "v${version}";
    hash = "sha256-OR+5AN3LYA4D+xY3KO8BloDqflBlB+ZNSIcXKEOYiL0=";
  };
in

recurseIntoAttrs {
  backend = callPackage ./backend.nix { inherit src version; };

  frontend = callPackage ./frontend.nix { inherit src version; };

  passthru.tests = {
    pingvin-share = nixosTests.pingvin-share;
  };
}
