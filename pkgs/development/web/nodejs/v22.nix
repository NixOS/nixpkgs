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
  version = "22.8.0";
  sha256 = "f130e82176d1ee0702d99afc1995d0061bf8ed357c38834a32a08c9ef74f1ac7";
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
