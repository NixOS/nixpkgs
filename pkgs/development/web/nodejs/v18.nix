{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "18.3.0";
  sha256 = "sha256-P2lKgWJuUFfNpXiY53HSE8/FpkmFX0zxxvbNFQxTBiU=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
  ];
}
