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
    version = "0.H";

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      tag = "${version}-RELEASE";
      sha256 = "sha256-ZCD5qgqYSX7sS+Tc1oNYq9soYwNUUuWamY2uXfLjGoY=";
    };

    patches = [
      # fix compilation of the vendored flatbuffers under gcc14
      (fetchpatch {
        name = "fix-flatbuffers-with-gcc14";
        url = "https://github.com/CleverRaven/Cataclysm-DDA/commit/1400b1018ff37196bd24ba4365bd50beb571ac14.patch";
        hash = "sha256-H0jct6lSQxu48eOZ4f8HICxo89qX49Ksw+Xwwtp7iFM=";
      })
      # Unconditionally look for translation files in $out/share/locale
      ./locale-path.patch
    ];

    meta = common.meta // {
      changelog = "https://github.com/CleverRaven/Cataclysm-DDA/blob/${version}/data/changelog.txt";
    };
  });
in

attachPkgs pkgs self
