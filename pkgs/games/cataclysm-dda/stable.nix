{
  lib,
  callPackage,
  fetchFromGitHub,
  fetchpatch,
  pkgs,
  wrapCDDA,
  attachPkgs,
  tiles ? true,
  debug ? false,
  useXdgDir ? false,
}:

let
  common = callPackage ./common.nix {
    inherit tiles debug useXdgDir;
  };

  self = common.overrideAttrs (common: rec {
    version = "0.H-2025-07-10-0402";

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      # Head of 0.H-branch
      tag = "cdda-${version}";
      sha256 = "sha256-r4cl8cij68WmQRfg+DHQIeDBIwhgwSre6kAUYZaCPR8=n";
    };

    patches = [
      # Unconditionally look for translation files in $out/share/locale
      ./locale-path.patch
    ];

    meta = common.meta // {
      changelog = "https://github.com/CleverRaven/Cataclysm-DDA/blob/${version}/data/changelog.txt";
    };
  });
in

attachPkgs pkgs self
