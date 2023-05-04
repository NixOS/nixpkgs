{ callPackage, openssl, fetchpatch, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

in
buildNodejs {
  inherit enableNpm;
  version = "20.0.0";
  sha256 = "sha256-dFDnV5Vo99HLOYGFz85HLaKDeyqjbFliCyLOS5d7XLU=";
  patches = [
    ./revert-arm64-pointer-auth.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
  ];
}
