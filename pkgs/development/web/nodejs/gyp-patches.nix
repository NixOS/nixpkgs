{
  lib,
  fetchpatch2,
  patch_npm ? true,
  patch_tools ? true,
}:
let
  url = "https://github.com/nodejs/gyp-next/commit/8224deef984add7e7afe846cfb82c9d3fa6da1fb.patch?full_index=1";
in
lib.optionals patch_tools [
  # Fixes builds with Nix sandbox on Darwin for gyp.
  (fetchpatch2 {
    inherit url;
    hash = "sha256-kvCMpedjrY64BlaC1R0NVjk/vIVivYAGVgWwMEGeP6k=";
    stripLen = 1;
    extraPrefix = "tools/gyp/";
  })
]
++ lib.optionals patch_npm [
  (fetchpatch2 {
    inherit url;
    hash = "sha256-cXTwmCRHrNhuY1+3cD/EvU0CJ+1Nk4TRh6c3twvfaW8=";
    stripLen = 1;
    extraPrefix = "deps/npm/node_modules/node-gyp/gyp/";
  })
]
++ [
  ./gyp-patches-set-fallback-value-for-CLT-darwin.patch
]
