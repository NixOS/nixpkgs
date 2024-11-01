{ callPackage, lib, overrideCC, pkgs, buildPackages, openssl, python311, fetchpatch2, enableNpm ? true }:

let
  # Clang 16+ cannot build Node v18 due to -Wenum-constexpr-conversion errors.
  # Use an older version of clang with the current libc++ for compatibility (e.g., with icu).
  ensureCompatibleCC = packages:
    if packages.stdenv.cc.isClang && lib.versionAtLeast (lib.getVersion packages.stdenv.cc.cc) "16"
      then overrideCC packages.llvmPackages_15.stdenv (packages.llvmPackages_15.stdenv.cc.override {
        inherit (packages.llvmPackages) libcxx;
      })
      else packages.stdenv;

  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    stdenv = ensureCompatibleCC pkgs;
    buildPackages = buildPackages // { stdenv = ensureCompatibleCC buildPackages; };
    python = python311;
  };

  gypPatches = callPackage ./gyp-patches.nix { } ++ [
    ./gyp-patches-pre-v22-import-sys.patch
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "18.20.4";
  sha256 = "sha256-p2x+oblq62ljoViAYmDICUtiRNZKaWUp0CBUe5qVyio=";
  patches = [
    ./configure-emulator-node18.patch
    ./configure-armv6-vfpv2.patch
    ./disable-darwin-v8-system-instrumentation.patch
    ./bypass-darwin-xcrun-node16.patch
    ./revert-arm64-pointer-auth.patch
    ./node-npm-build-npm-package-logic.patch
    ./trap-handler-backport.patch
    ./use-correct-env-in-tests.patch
    ./v18-openssl-3.0.14.patch
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/534c122de166cb6464b489f3e6a9a544ceb1c913.patch";
      hash = "sha256-4q4LFsq4yU1xRwNsM1sJoNVphJCnxaVe2IyL6AeHJ/I=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/87598d4b63ef2c827a2bebdfa0f1540c35718519.patch";
      hash = "sha256-JJi8z9aaWnu/y3nZGOSUfeNzNSCYzD9dzoHXaGkeaEA=";
      includes = ["test/common/assertSnapshot.js"];
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/d0a6b605fba6cd69a82e6f12ff0363eef8fe1ee9.patch";
      hash = "sha256-TfYal/PikRZHL6zpAlC3SmkYXCe+/8Gs83dLX/X/P/k=";
    })

    # Patches for OpenSSL 3.2
    # Patches already in 20.13.0
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/9f939f5af7d11299796999af3cbfa4845b505c78.patch?full_index=1";
      hash = "sha256-vZJMTI8KR+RoCl4r9dfNdNMKssk4osLS61A/F7gdeWQ=";
    })
    # Patches already in 20.16.0
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/5909cf3b047f708de6a1373232bfcc899fa97a1d.patch?full_index=1";
      hash = "sha256-JidSO/73fjxTcGBiMHC7x10muYtv04inXNVJebFmcgo=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/ce531af0c27acf29dd05ab2fac19b4af88f8780d.patch?full_index=1";
      hash = "sha256-2WD4lVCtfji0AXlIHq4tiQ2TWKVMPjYZjbaVxd3HEFw=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/3e7129e5d60d4f017ad06c006dec7f95d986095c.patch?full_index=1";
      hash = "sha256-2SRoUMswY25GamJ6APVAzDwqopSCpVPKAEIIqyaAmBA=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/da0f19208786cd7c57fec733e4ba24d0454f556a.patch?full_index=1";
      hash = "sha256-AyQe2eHIx0O2jUgMCqWnzLhW8XduPaU4ZmhFA3UQI+Q=";
    })
    # Patches already in 20.17.0
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/53ac448022b7cdfcc09296da88d9a1b59921f6bf.patch?full_index=1";
      hash = "sha256-JcEbluU9k20Q3W915D1O6wWgX5R/UKjxqsuDemjMoTc=";
    })
    # Patches already in 22.7.0
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/bd42e4c6a73f61f7ee47e4426d86708fd80c6c4f.patch?full_index=1";
      hash = "sha256-bsCLVwK5t8dD+wHd1FlFJ1wpCGtNGcwoOfq4fG5MHfo=";
      includes = ["test/parallel/test-tls-set-sigalgs.js"];
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/e0634f58aba6a1634fe03107d5be849fd008cc02.patch?full_index=1";
      hash = "sha256-Jh7f4JPS1H2Rpj1nEOW53E66Z+GDNEFXl0jALrvyYXQ=";
    })
    # Patches already in 22.8.0
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/e9cd4766e39d96693320be9ce0a1044c450e8675.patch?full_index=1";
      hash = "sha256-RXRLRznz16B8MrfVrpIHgyqLV2edpJk2p717QBttyK4=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/2bfc9e467cb05578efa4d3db497f368fb144e5fc.patch?full_index=1";
      hash = "sha256-TyHSd+O0T/bFR7YZuxm4HumrMljnJu2a8RRLRvz6KNM=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/01f751b529d126529f1d2019f0dcb13b8e54b787.patch?full_index=1";
      hash = "sha256-m3IaWL7U8fQMnmP2Xch4M8Qn1AJU8Ao9GCqMPcDnqCk=";
    })
    # Patches already in 22.9.0
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/d9ca8b018efd172a99365ada8f536491b19bd87b.patch?full_index=1";
      hash = "sha256-KzoWVXcgjJaMUOXDyLlkwRcN6z3SdFhTJd0KYBYfElE=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/c4f295470392db237c0adfc9832214538a99a034.patch?full_index=1";
      hash = "sha256-sYTY+oiQ5K7bYLcI1+jSTlLFdwpteKGSu7S/bbaslLE=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/a65105ec284023960e93b3a66f6661ddd2f4121f.patch?full_index=1";
      hash = "sha256-ZNkiHlp+UlbnonPBhMUw6rqtjWrC1b9SgI9EcGhDlwY=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/c77bcf018716e97ae35203990bcd51c143840348.patch?full_index=1";
      hash = "sha256-EwrZKpLRzk3Yjen1WVQqKTiHKE2uLTpaPsE13czH2rY=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/18101d83a158b877ac765936aba973c664130ea2.patch?full_index=1";
      hash = "sha256-vpHDj5+340bjYLo7gTWFu7iS4vVveBZAMypQ2eLoQzM=";
    })
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
