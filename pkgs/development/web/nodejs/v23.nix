{
  lib,
  stdenv,
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
in
buildNodejs {
  inherit enableNpm;
  version = "23.11.0";
  sha256 = "f2c5db21fc5d3c3d78c7e8823bff770cef0da8078c3b5ac4fa6d17d5a41be99d";
  patches =
    [
      ./configure-emulator.patch
      ./configure-armv6-vfpv2.patch
      ./disable-darwin-v8-system-instrumentation-node19.patch
      ./bypass-darwin-xcrun-node16.patch
      ./node-npm-build-npm-package-logic.patch
      ./use-correct-env-in-tests.patch
      ./bin-sh-node-run-v22.patch

    ]
    ++ lib.optionals (!stdenv.buildPlatform.isDarwin) [
      # test-icu-env is failing without the reverts
      (fetchpatch2 {
        url = "https://github.com/nodejs/node/commit/869d0cbca3b0b5e594b3254869a34d549664e089.patch?full_index=1";
        hash = "sha256-BBBShQwU20TSY8GtPehQ9i3AH4ZKUGIr8O0bRsgrpNo=";
        revert = true;
      })
    ];
}
