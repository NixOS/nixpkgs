{ lib, callPackage, CoreFoundation, fetchFromGitHub, pkgs, wrapCDDA, attachPkgs
, tiles ? true, Cocoa
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
    ];

    makeFlags = common.makeFlags ++ [
      # Makefile declares version as 0.F, with no minor release number
      "VERSION=${version}"
    ];

    meta = common.meta // {
      maintainers = with lib.maintainers;
      common.meta.maintainers ++ [ skeidel ];
    };
  });
in

attachPkgs pkgs self
