{
  lib,
  callPackage,
  CoreFoundation,
  fetchFromGitHub,
  fetchpatch,
  pkgs,
  wrapCDDA,
  attachPkgs,
  tiles ? true,
  Cocoa,
  debug ? false,
  useXdgDir ? false,
}:

let
  common = callPackage ./common.nix {
    inherit
      CoreFoundation
      tiles
      Cocoa
      debug
      useXdgDir
      ;
  };

  self = common.overrideAttrs (common: rec {
    version = "0.G";

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      rev = version;
      sha256 = "sha256-Hda0dVVHNeZ8MV5CaCbSpdOCG2iqQEEmXdh16vwIBXk=";
    };

    patches = [
      # Unconditionally look for translation files in $out/share/locale
      ./locale-path.patch
      # Fixes for failing build with GCC 13, remove on updating next release after 0.G
      (fetchpatch {
        url = "https://sources.debian.org/data/main/c/cataclysm-dda/0.G-4/debian/patches/gcc13-dangling-reference-warning.patch";
        hash = "sha256-9nPbyz49IYBOVHqr7jzCIyS8z/SQgpK4EjEz1fruIPE=";
      })
      (fetchpatch {
        url = "https://sources.debian.org/data/main/c/cataclysm-dda/0.G-4/debian/patches/gcc13-cstdint.patch";
        hash = "sha256-8IBW2OzAHVgEJZoViQ490n37sl31hA55ePuqDL/lil0=";
      })
      (fetchpatch {
        url = "https://sources.debian.org/data/main/c/cataclysm-dda/0.G-4/debian/patches/gcc13-keyword-requires.patch";
        hash = "sha256-8yvHh0YKC7AC/qzia7AZAfMewMC0RiSepMXpOkMXRd8=";
      })
      # Fix build w/ glibc-2.39
      # From https://github.com/BrettDong/Cataclysm-DDA/commit/9b206e2dc969ad79345596e03c3980bd155d2f48
      ./glibc-2.39.diff
    ];

    makeFlags = common.makeFlags ++ [
      # Makefile declares version as 0.F, with no minor release number
      "VERSION=${version}"
    ];

    env.NIX_CFLAGS_COMPILE = toString [
      # Needed with GCC 12
      "-Wno-error=array-bounds"
    ];

    meta = common.meta // {
      maintainers = with lib.maintainers; common.meta.maintainers;
      changelog = "https://github.com/CleverRaven/Cataclysm-DDA/blob/${version}/data/changelog.txt";
    };
  });
in

attachPkgs pkgs self
