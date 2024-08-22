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
  version = "22.7.0";
  sha256 = "1e0b6f2f2ca4fb0b4644a11363169daf4b7c42f00e5a53d2c65a9fdc463e7d88";
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
