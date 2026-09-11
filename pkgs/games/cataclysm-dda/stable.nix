{
  callPackage,
  fetchFromGitHub,
  pkgs,
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
    # 0.I is the latest stable release tag (https://github.com/CleverRaven/Cataclysm-DDA/releases/tag/0.I)
    version = "0.I-2026-06-11-1250";

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      tag = "cdda-${version}";
      hash = "sha256-DpB9OlSpg0t4L1JdMMPeQC+cLd0zs/ZkCdXSFGWgRhA=";
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
