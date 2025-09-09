{
  callPackage,
  fetchpatch2,
  openssl,
  python3,
  enableNpm ? true,
}:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  gypPatches = callPackage ./gyp-patches.nix { } ++ [
    ./gyp-patches-pre-v22-import-sys.patch
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "20.19.5";
  sha256 = "230c899f4e2489c4b8d2232edd6cc02f384fb2397c2a246a22e415837ee5da51";
  patches = [
    ./configure-emulator.patch
    ./configure-armv6-vfpv2.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch
  ]
  ++ gypPatches;
}
