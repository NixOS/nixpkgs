{
  lib,
  fetchpatch2,
  patch_npm ? true,
  patch_tools ? true,
}:
let
  url = "https://github.com/nodejs/gyp-next/commit/706d04aba5bd18f311dc56f84720e99f64c73466.patch?full_index=1";
in
lib.optionals patch_tools ([
  # Fixes builds with Nix sandbox on Darwin for gyp.
  # See https://github.com/NixOS/nixpkgs/issues/261820
  # and https://github.com/nodejs/gyp-next/pull/216
  (fetchpatch2 {
    inherit url;
    hash = "sha256-iV9qvj0meZkgRzFNur2v1jtLZahbqvSJ237NoM8pPZc=";
    stripLen = 1;
    extraPrefix = "tools/gyp/";
  })
])
++ lib.optionals patch_npm ([
  (fetchpatch2 {
    inherit url;
    hash = "sha256-1iyeeAprmWpmLafvOOXW45iZ4jWFSloWJxQ0reAKBOo=";
    stripLen = 1;
    extraPrefix = "deps/npm/node_modules/node-gyp/gyp/";
  })
])
