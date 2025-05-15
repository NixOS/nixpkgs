{ lib, callPackage, fetchFromGitHub, fetchpatch, pkgs, wrapCDDA, attachPkgs
, tiles ? true
, debug ? false
, useXdgDir ? false
, version ? "2025-05-14"
, rev ? "5fe71bf02f544436e0f218ed53f4a4f0f560be6b"
, sha256 ? "sha256-hfeHrvZjo7ttLG4SQmlJ//xUt8wUU9DY1K9FrVpZKGA="
}:

let
  desktopFilePath = "";

  common = callPackage ./common.nix {
    inherit tiles debug useXdgDir desktopFilePath;
  };

  self = common.overrideAttrs (common: rec {
    pname = "cataclysm-bn-git";
    inherit version;

    src = fetchFromGitHub {
      owner = "cataclysmbnteam";
      repo = "Cataclysm-BN";
      inherit rev sha256;
    };

    patches = [
      # Unfortunately some READMEs in data are symlinks to doc which is not included
      # resulting in dangling symlinks breaking build
      ./delete-dangling-readme.patch
    ];

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
