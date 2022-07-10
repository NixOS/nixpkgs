{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "18.5.0";
  sha256 = "0c50y6c52pmbxc8x1zhkzq608bwvcma4fj39cd1mvc40wfa5d2rn";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
  ];
}
