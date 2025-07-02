{
  lib,
  stdenv,
  buildPackages,
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
  version = "24.3.0";
  sha256 = "eb688ef8a63fda9ebc0b5f907609a46e26db6d9aceefc0832009a98371e992ed";
  patches =
    (
      if (stdenv.hostPlatform.emulatorAvailable buildPackages) then
        [
          ./configure-emulator.patch
        ]
      else
        [
          (fetchpatch2 {
            url = "https://raw.githubusercontent.com/buildroot/buildroot/2f0c31bffdb59fb224387e35134a6d5e09a81d57/package/nodejs/nodejs-src/0003-include-obj-name-in-shared-intermediate.patch";
            hash = "sha256-3g4aS+NmmUYNOYRNc6UMJKYoaTlpP5Knt9UHegx+o0Y=";
          })
        ]
    )
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform.isFreeBSD) [
      # This patch is concerning.
      # https://github.com/nodejs/node/issues/54576
      # It is only supposed to affect clang >= 17, but I'm seeing it on clang 19.
      # I'm keeping the predicate for this patch pretty strict out of caution,
      # so if you see the error it's supposed to prevent, feel free to loosen it.
      (fetchpatch2 {
        url = "https://raw.githubusercontent.com/rubyjs/libv8-node/62476a398d4c9c1a670240a3b070d69544be3761/patch/v8-no-assert-trivially-copyable.patch";
        hash = "sha256-hSTLljmVzYmc3WAVeRq9EPYluXGXFeWVXkykufGQPVw=";
      })
    ]
    ++ [
      ./configure-armv6-vfpv2.patch
      ./disable-darwin-v8-system-instrumentation-node19.patch
      ./bypass-darwin-xcrun-node16.patch
      ./node-npm-build-npm-package-logic.patch
      ./use-correct-env-in-tests.patch
      ./bin-sh-node-run-v22.patch

      # Fix for flaky test
      # TODO: remove when included in a release
      (fetchpatch2 {
        url = "https://github.com/nodejs/node/commit/cd685fe3b6b18d2a1433f2635470513896faebe6.patch?full_index=1";
        hash = "sha256-KA7WBFnLXCKx+QVDGxFixsbj3Y7uJkAKEUTeLShI1Xo=";
      })
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
