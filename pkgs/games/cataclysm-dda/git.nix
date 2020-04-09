{ lib, callPackage, CoreFoundation, fetchFromGitHub, pkgs, wrapCDDA
, tiles ? true, Cocoa
, debug ? false
}:

let
  common = callPackage ./common.nix {
    inherit CoreFoundation tiles Cocoa debug;
  };

  self = common.overrideAttrs (common: rec {
    pname = common.pname + "-git";
    version = "2019-11-22";

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      rev = "a6c8ece992bffeae3788425dd4b3b5871e66a9cd";
      sha256 = "0ww2q5gykxm802z1kffmnrfahjlx123j1gfszklpsv0b1fccm1ab";
    };

    makeFlags = common.makeFlags ++ [
      "VERSION=git-${version}-${lib.substring 0 8 src.rev}"
    ];

    passthru = common.passthru // {
      pkgs = pkgs.override { build = self; };
      withMods = wrapCDDA self;
    };

    meta = common.meta // {
      maintainers = with lib.maintainers;
      common.meta.maintainers ++ [ rardiol ];
    };
  });
in

self
