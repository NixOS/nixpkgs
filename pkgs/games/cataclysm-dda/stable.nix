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
    # 0.I-1 is the latest stable release (https://github.com/CleverRaven/Cataclysm-DDA/releases/tag/0.I-1)
    version = "0.I-1";

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      tag = version;
      hash = "sha256-FO9Gn6fbmz1jGAKIbpATnnu6C1zRFJbTlkJ5IytVpIA=";
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
