{ lib
, callPackage
, CoreFoundation
, fetchFromGitHub
, fetchpatch
, pkgs
, wrapCDDA
, attachPkgs
, tiles ? true
, Cocoa
, debug ? false
, useXdgDir ? false
}:

let
  common = callPackage ./common.nix {
    inherit CoreFoundation tiles Cocoa debug useXdgDir;
  };

  self = common.overrideAttrs (common: rec {
    version = "0.F-3";

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      rev = version;
      sha256 = "sha256-2su1uQaWl9WG41207dRvOTdVKcQsEz/y0uTi9JX52uI=";
    };

    patches = [
      # Unconditionally look for translation files in $out/share/locale
      ./locale-path-stable.patch

      # Fixes compiler errors when compiling against SDL2_ttf >= 1.20.0, https://github.com/CleverRaven/Cataclysm-DDA/pull/59083
      # Remove with next version update.
      (fetchpatch {
        url = "https://github.com/CleverRaven/Cataclysm-DDA/commit/625fadf3d493c1712d9ade2b849ff6a79765c7a7.patch";
        hash = "sha256-c0NXkd6jSGSruKrwuYUmLbgiL97YQDkUm313fnMJ7GA=";
      })
    ];

    makeFlags = common.makeFlags ++ [
      # Makefile declares version as 0.F, with no minor release number
      "VERSION=${version}"
    ];

    NIX_CFLAGS_COMPILE = [
      # Needed with GCC 12
      "-Wno-error=array-bounds"
    ];

    meta = common.meta // {
      maintainers = with lib.maintainers;
        common.meta.maintainers ++ [ skeidel ];
    };
  });
in

attachPkgs pkgs self
