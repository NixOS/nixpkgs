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
  version = "23.8.0";
  sha256 = "6ec5d54d0e8423fc5986f6efa4f661e8370659818b14f458cdc9d1b9f75d3b88";
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
