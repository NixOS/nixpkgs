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
      callPackage ./gyp-patches.nix { }
      ++ [
        ./gyp-patches-set-fallback-value-for-CLT.patch
      ]
    else
      [ ];
in
buildNodejs {
  inherit enableNpm;
  version = "22.19.0";
  sha256 = "0272acfce50ce9ad060288321b1092719a7f19966f81419835410c59c09daa46";
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

      # TODO: remove when included in a release
      (fetchpatch2 {
        url = "https://github.com/nodejs/node/commit/499a5c345165f0d4a94b98d08f1ace7268781564.patch?full_index=1";
        hash = "sha256-wF4+CytC1OB5egJGOfLm1USsYY12f9kADymVrxotezE=";
      })
    ];
}
