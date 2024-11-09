{ lib, callPackage, CoreFoundation, fetchFromGitHub, fetchpatch, pkgs, wrapCDDA, attachPkgs
, tiles ? true, Cocoa
, debug ? false
, useXdgDir ? false
, version ? "2024-10-18"
, rev ? "551c7279dafe1d283c3ef2779cb335b855e6bc59"
, sha256 ? "sha256-1xXTGNjLma5++xIEf9n98lPAZZ+nJ7TPMS6S5n4PSzs="
}:

let
  desktopFilePath = "";

  common = callPackage ./common.nix {
    inherit CoreFoundation tiles Cocoa debug useXdgDir desktopFilePath;
  };

  self = common.overrideAttrs (common: rec {
    pname = "cataclysm-bn-git";
    inherit version;

    src = fetchFromGitHub {
      owner = "cataclysmbnteam";
      repo = "Cataclysm-BN";
      inherit rev sha256;
    };

    makeFlags = common.makeFlags ++ [
      "VERSION=git-${version}-${lib.substring 0 8 src.rev}"
    ];

    meta = common.meta // {
      maintainers = with lib.maintainers;
      common.meta.maintainers ++ [ rardiol ];
    };
  });
in

attachPkgs pkgs self
