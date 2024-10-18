{ callPackage, fetchpatch2, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  gypPatches = callPackage ./gyp-patches.nix { } ++ [
    ./gyp-patches-pre-v22-import-sys.patch
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "20.17.0";
  sha256 = "9abf03ac23362c60387ebb633a516303637145cb3c177be3348b16880fd8b28c";
  patches = [
    ./configure-emulator.patch
    ./configure-armv6-vfpv2.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch

    # Patches for OpenSSL 3.2
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
