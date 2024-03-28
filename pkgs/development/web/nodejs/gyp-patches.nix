{ fetchpatch }:
let
  name = "darwin-sandbox.patch";
  url = "https://github.com/nodejs/gyp-next/pull/216.patch";
in
[
  # Fixes builds with Nix sandbox on Darwin for gyp.
  # See https://github.com/NixOS/nixpkgs/issues/261820
  (fetchpatch {
    inherit name url;
    hash = "sha256-TRmeJWPfdY1Sd9IooueHc83HsYL/C1CcKv96nXEbeXU=";
    stripLen = 1;
    extraPrefix = "tools/gyp/";
  })
  (fetchpatch {
    inherit name url;
    hash = "sha256-FErwEZSO/B2HhoWjaRw8iV9vBMRePy4Co+0GXrHm6k0=";
    stripLen = 1;
    extraPrefix = "deps/npm/node_modules/node-gyp/gyp/";
  })
]
