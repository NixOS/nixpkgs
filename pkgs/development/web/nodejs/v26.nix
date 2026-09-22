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
  version = "26.10.0";
  sha256 = "7b3a546d33cb7e15a43bdd7a57e0be5d5fd5ffc553e6e4c120033e66f0ba20c5";
  patches =
    (lib.optional (!(stdenv.hostPlatform.emulatorAvailable buildPackages)) (fetchpatch2 {
      url = "https://raw.githubusercontent.com/buildroot/buildroot/2f0c31bffdb59fb224387e35134a6d5e09a81d57/package/nodejs/nodejs-src/0003-include-obj-name-in-shared-intermediate.patch";
      hash = "sha256-3g4aS+NmmUYNOYRNc6UMJKYoaTlpP5Knt9UHegx+o0Y=";
    }))
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

      ./fix-temporal-integration-with-shared-icu.patch

      # Upstream started requiring shared simdutf built with atomic support. Reverting that on 26.05.
      (fetchpatch2 {
        url = "https://github.com/nodejs/node/commit/7e3d61c416407bb5259f63a007df16bcc3c715ef.patch?full_index=1";
        hash = "sha256-uxAPKrYXrgfF42Kh73suHc71drfkJvypHbKTdUktKnM=";
        includes = [ "deps/v8/src/*" ];
        revert = true;
      })
      (fetchpatch2 {
        url = "https://github.com/nodejs/node/commit/f3ae4554feb2d043cdc3d24898f6173add1fcac8.patch?full_index=1";
        hash = "sha256-+P+6pMBcG2Utcg2aPQTDdYOy/9bdkX7X/gttXNghDYM=";
        excludes = [
          ".github/workflows/test-shared.yml"
          "tools/nix/*"
          "shell.nix"
        ];
        revert = true;
      })
    ]
    ++ gypPatches;
}
