{
  lib,
  stdenv,
  fetchpatch2,
  patch_npm ? true,
  patch_tools ? true,
  patch_npm_catch_oserror ? patch_npm,
  patch_tools_catch_oserror ? patch_tools,
  patch_npm_regex_handling ? patch_npm && stdenv.buildPlatform.isDarwin,
  patch_tools_regex_handling ? patch_tools && stdenv.buildPlatform.isDarwin,
}:
let
  url = "https://github.com/nodejs/gyp-next/commit/8224deef984add7e7afe846cfb82c9d3fa6da1fb.patch?full_index=1";
  url_regex_handling = "https://github.com/nodejs/gyp-next/commit/b21ee3150eea9fc1a8811e910e5ba64f42e1fb77.patch?full_index=1";
in
lib.optionals patch_tools_catch_oserror ([
  # Fixes builds with Nix sandbox on Darwin for gyp.
  (fetchpatch2 {
    inherit url;
    hash = "sha256-kvCMpedjrY64BlaC1R0NVjk/vIVivYAGVgWwMEGeP6k=";
    stripLen = 1;
    extraPrefix = "tools/gyp/";
  })
])
++ lib.optionals patch_npm_catch_oserror ([
  (fetchpatch2 {
    inherit url;
    hash = "sha256-cXTwmCRHrNhuY1+3cD/EvU0CJ+1Nk4TRh6c3twvfaW8=";
    stripLen = 1;
    extraPrefix = "deps/npm/node_modules/node-gyp/gyp/";
  })
])
++ lib.optionals patch_tools_regex_handling ([
  # Fixes builds with Nix sandbox on Darwin for gyp.
  (fetchpatch2 {
    url = url_regex_handling;
    hash = "sha256-xDZO8GgZLPvCeTrCu6RVVFV5bmbuz9UPgHiaAJE6im0=";
    stripLen = 1;
    extraPrefix = "tools/gyp/";
  })
])
++ lib.optionals patch_npm_regex_handling ([
  (fetchpatch2 {
    url = url_regex_handling;
    hash = "sha256-fW5kQh+weCK0g3wzTJLZgAuXxetb14UAf6yxW6bIgbU=";
    stripLen = 1;
    extraPrefix = "deps/npm/node_modules/node-gyp/gyp/";
  })
])
# TODO: remove the Darwin conditionals from this file
++ lib.optionals stdenv.buildPlatform.isDarwin ([
  ./gyp-patches-set-fallback-value-for-CLT-darwin.patch
])
