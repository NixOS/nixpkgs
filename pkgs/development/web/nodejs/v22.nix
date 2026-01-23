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

  gypPatches =
    if stdenv.buildPlatform.isDarwin then
      callPackage ./gyp-patches.nix { patch_tools = false; }
    else
      [ ];
in
buildNodejs {
  inherit enableNpm;
  version = "22.22.0";
  sha256 = "4c138012bb5352f49822a8f3e6d1db71e00639d0c36d5b6756f91e4c6f30b683";
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
    ++ gypPatches
    ++ [
      ./configure-armv6-vfpv2.patch
      ./node-npm-build-npm-package-logic.patch
      ./use-correct-env-in-tests.patch
      ./bin-sh-node-run-v22.patch
      ./use-nix-codesign.patch
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
      # Fix builds with shared llhttp
      (fetchpatch2 {
        url = "https://github.com/nodejs/node/commit/ff3a028f8bf88da70dc79e1d7b7947a8d5a8548a.patch?full_index=1";
        hash = "sha256-LJcO3RXVPnpbeuD87fiJ260m3BQXNk3+vvZkBMFUz5w=";
      })
      # update tests for nghttp2 1.65
      ./deprecate-http2-priority-signaling.patch
      (fetchpatch2 {
        url = "https://github.com/nodejs/node/commit/a63126409ad4334dd5d838c39806f38c020748b9.diff?full_index=1";
        hash = "sha256-lfq8PMNvrfJjlp0oE3rJkIsihln/Gcs1T/qgI3wW2kQ=";
        includes = [ "test/*" ];
      })
    ];
}
