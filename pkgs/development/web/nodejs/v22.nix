{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  gypPatches = callPackage ./gyp-patches.nix { } ++ [
    ./gyp-patches-v22-import-sys.patch
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "22.6.0";
  sha256 = "37259d618d5565ca55acc2585045c7e1c5b9965a3d4eb44c0a237fdae84b9d44";
  patches = [
    ./configure-emulator.patch
    ./configure-armv6-vfpv2.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch
    ./bin-sh-node-run-v22.patch
  ] ++ gypPatches;
}
