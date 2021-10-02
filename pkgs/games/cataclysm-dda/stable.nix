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
    version = "0.F-2";

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      rev = version;
      sha256 = "sha256-8AZOrO/Wxui+LqAZo8hURktMTycecIgOONUJmE3M+vM=";
    };

    makeFlags = common.makeFlags ++ [
      # Makefile declares version as 0.F, even under 0.F-2
      "VERSION=${version}"
    ];

    meta = common.meta // {
      maintainers = with lib.maintainers;
      common.meta.maintainers ++ [ skeidel ];
    };
  });
in

attachPkgs pkgs self
