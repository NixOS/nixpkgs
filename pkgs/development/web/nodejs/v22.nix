{ callPackage, fetchpatch2, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  gypPatches = callPackage ./gyp-patches.nix { } ++ [
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "22.9.0";
  sha256 = "a55aeb368dee93432f610127cf94ce682aac07b93dcbbaadd856df122c9239df";
  patches = [
    ./configure-emulator.patch
    ./configure-armv6-vfpv2.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch
    ./bin-sh-node-run-v22.patch

    # Patches for OpenSSL 3.2
    # Patches not yet released
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/f8b7a171463e775da304bccf4cf165e634525c7e.patch?full_index=1";
      hash = "sha256-imptUwt2oG8pPGKD3V6m5NQXuahis71UpXiJm4C0E6o=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/6dfa3e46d3d2f8cfba7da636d48a5c41b0132cd7.patch?full_index=1";
      hash = "sha256-ITtGsvZI6fliirCKvbMH9N2Xoy3001bz+hS3NPoqvzg=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/29b9c72b05786061cde58a5ae11cfcb580ab6c28.patch?full_index=1";
      hash = "sha256-xaqtwsrOIyRV5zzccab+nDNG8kUgO6AjrVYJNmjeNP0=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/cfe58cfdc488da71e655d3da709292ce6d9ddb58.patch?full_index=1";
      hash = "sha256-9GblpbQcYfoiE5R7fETsdW7v1Mm2Xdr4+xRNgUpLO+8=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/2cec716c48cea816dcd5bf4997ae3cdf1fe4cd90.patch?full_index=1";
      hash = "sha256-ExIkAj8yRJEK39OfV6A53HiuZsfQOm82/Tvj0nCaI8A=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/0f7bdcc17fbc7098b89f238f4bd8ecad9367887b.patch?full_index=1";
      hash = "sha256-lXx6QyD2anlY9qAwjNMFM2VcHckBshghUF1NaMoaNl4=";
    })
  ] ++ gypPatches;
}
