{
  lib,
  stdenv,
  buildPackages,
  callPackage,
  fetchpatch2,
  openssl,
  python3,
}:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  gypPatches =
    if stdenv.buildPlatform.isDarwin then
      [
        ./gyp-patches-set-fallback-value-for-CLT-darwin.patch
      ]
    else
      [ ];
in
buildNodejs {
  version = "24.14.1";
  sha256 = "7822507713f202cf2a551899d250259643f477b671706db421a6fb55c4aa0991";
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
      ./node-npm-build-npm-package-logic.patch
      ./use-correct-env-in-tests.patch
      ./bin-sh-node-run-v22.patch
      ./use-nix-codesign.patch

      # TODO: remove this when included in a next release
      (fetchpatch2 {
        url = "https://github.com/nodejs/node/commit/a5e534c21af49ae1b34854846b6913daa7df0808.patch?full_index=1";
        hash = "sha256-4cr94fsJrq5iCAHOf60wJQQkP/K2YWYY5W7GHs8Sbxg=";
        includes = [ "test/*" ];
      })
      (fetchpatch2 {
        url = "https://github.com/nodejs/node/commit/59a522af24173b244cb86829de145d46b143a45c.patch?full_index=1";
        hash = "sha256-mjxl4rIio8lgjvxqfKrVwdhOUHUUDH2PMh0n8BowXIQ=";
        includes = [ "src/*" ];
      })
    ]
    ++ gypPatches
    ++ lib.optionals (!stdenv.buildPlatform.isDarwin) [
      # test-icu-env is failing without the reverts
      (fetchpatch2 {
        url = "https://github.com/nodejs/node/commit/869d0cbca3b0b5e594b3254869a34d549664e089.patch?full_index=1";
        hash = "sha256-BBBShQwU20TSY8GtPehQ9i3AH4ZKUGIr8O0bRsgrpNo=";
        revert = true;
      })
    ]
    ++ lib.optionals stdenv.hostPlatform.is32bit [
      # see: https://github.com/nodejs/node/issues/58458
      ./v24-32bit.patch
      # TODO: remove once included in an future upstream release
      (fetchpatch2 {
        url = "https://github.com/nodejs/node/commit/f13d7bf69a7f1642fb5b1b624eff1a50ceb71849.patch?full_index=1";
        hash = "sha256-4PZq1gG/K+FwAM06VIXYoSNJeOYe37kfKW0jqczeXbc=";
      })
    ];
}
