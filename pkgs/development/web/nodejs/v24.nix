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
  version = "24.15.0";
  sha256 = "a4f653d79ed140aaad921e8c22a3b585ca85cfdab80d4030f6309e4663a8a1c8";
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
      # https://github.com/NixOS/nixpkgs/pull/507974#issuecomment-4249433124
      # OpenSSL reports different errors
      # https://github.com/nodejs/node/pull/62629
      (fetchpatch2 {
        url = "https://github.com/nodejs/node/commit/dd25d8f29d3ddadcf5a5ebfdf98ece55f9df96c6.patch?full_index=1";
        hash = "sha256-6cxRN7TyWmJgUZt3jp2YXbVIjrDb2BNep5LxBOtT3Q0=";
      })

      # Patch for nghttp2 1.69 support
      (fetchpatch2 {
        url = "https://github.com/nodejs/node/commit/4a32c00fb8dbe55c3bcf9ef43343968c9fe449e6.diff?full_index=1";
        hash = "sha256-pex8ruwa4b/vWvfGA+nyN3JJP8NOturmwAQe4Rkd6nU=";
        excludes = [ "tools/nix/*" ];
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
    ++ lib.optionals stdenv.is32bit [
      # see: https://github.com/nodejs/node/issues/58458
      ./v24-32bit.patch
    ];
}
