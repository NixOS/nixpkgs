{ callPackage
, fetchFromGitHub
, recurseIntoAttrs
, nixosTests
}:

let
  version = "0.25.0";
  src = fetchFromGitHub {
    owner = "stonith404";
    repo = "pingvin-share";
    rev = "v${version}";
    hash = "sha256-uwuW7n7pFCIV3/sDi6bYaJPWcK9Gc4xIZFidIN3Tq5E=";
  };
in

recurseIntoAttrs {
  backend = callPackage ./backend.nix { inherit src version; };

  frontend = callPackage ./frontend.nix { inherit src version; };

  passthru.tests = {
    pingvin-share = nixosTests.pingvin-share;
  };
}
