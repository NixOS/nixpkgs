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
    version = "0.F-1";

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      rev = version;
      sha256 = "sha256-bVIln8cLZ15qXpW5iB8Odqk0OQbNLLM8OiKybTzARA0=";
    };

    makeFlags = common.makeFlags ++ [
      # Makefile declares version as 0.F, even under 0.F-1
      "VERSION=${version}"
    ];

    meta = common.meta // {
      maintainers = with lib.maintainers;
      common.meta.maintainers ++ [ skeidel ];
    };
  });
in

attachPkgs pkgs self
