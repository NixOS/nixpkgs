{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "18.4.0";
  sha256 = "sha256-lNbxmpcDYfjIrRdFBgQJU4n1HKagDc3lnCHzc+lau7U=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
  ];
}
