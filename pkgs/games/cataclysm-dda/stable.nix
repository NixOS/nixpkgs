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
    version = "0.F";

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      rev = version;
      sha256 = "1jid8lcl04y768b3psj1ifhx96lmd6fn1j2wzxhl4ic7ra66p2z3";
    };

    meta = common.meta // {
      maintainers = with lib.maintainers;
      common.meta.maintainers ++ [ skeidel ];
    };
  });
in

attachPkgs pkgs self
