{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "17.9.0";
  sha256 = "1q1rr9kvlk9rd35x3x206iy894hq2ywyhqxbb6grak6wcvdgcnan";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
  ];
}
