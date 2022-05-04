{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "18.0.0";
  sha256 = "sha256-NE0OZUC1JMaal5/1w+eM2nJU/XLANpmSa+sLhVi4znU=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
  ];
}
