{ callPackage, fetchpatch, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "18.9.0";
  sha256 = "sha256-x1zImv6tl2eRkArM3gKnsefnYnAvD2+mjqrLAZhNllQ=";
  patches = [
    (fetchpatch {
      # Fixes cross compilation to aarch64-linux by reverting https://github.com/nodejs/node/pull/43200
      name = "revert-arm64-pointer-auth.patch";
      url = "https://github.com/nodejs/node/pull/43200/commits/d42c42cc8ac652ab387aa93205aed6ece8a5040a.patch";
      sha256 = "sha256-ipGzg4lEoftTJbt6sW+0QJO/AZqHvUkFKe0qlum+iLY=";
      revert = true;
    })

    ./disable-darwin-v8-system-instrumentation.patch
  ];
}
