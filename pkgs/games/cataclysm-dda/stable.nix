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
      maintainers = with lib.maintainers;
        common.meta.maintainers;
      changelog = "https://github.com/CleverRaven/Cataclysm-DDA/blob/${version}/data/changelog.txt";
    };
  });
in

attachPkgs pkgs self
