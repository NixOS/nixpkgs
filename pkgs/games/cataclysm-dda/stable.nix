{ lib, callPackage, CoreFoundation, fetchFromGitHub, pkgs, wrapCDDA
, tiles ? true, Cocoa
, debug ? false
, useXdgDir ? false
}:

let
  common = callPackage ./common.nix {
    inherit CoreFoundation tiles Cocoa debug useXdgDir;
  };

  self = common.overrideAttrs (common: rec {
    version = "0.E-3";

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      rev = version;
      sha256 = "qhHtsm5cM0ct/7qXev0SiLInO2jqs2odxhWndLfRDIE=";
    };

    passthru = common.passthru // {
      pkgs = pkgs.override { build = self; };
      withMods = wrapCDDA self;
    };

    meta = common.meta // {
      maintainers = with lib.maintainers;
      common.meta.maintainers ++ [ skeidel ];
    };
  });
in

self
