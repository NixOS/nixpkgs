{
  lib,
  callPackage,
  fetchFromGitHub,
  pkgs,
  attachPkgs,
  tiles ? true,
  debug ? false,
  useXdgDir ? false,
  version ? "2024-12-11",
  rev ? "b871679a2d54dbc6bf3e6566033fadd2dc651592",
  sha256 ? "sha256-t9R0QPky7zvjgGMq4kV8DdQFToJ/qngbJCw+8FlQztM=",
}:

let
  common = callPackage ./common.nix {
    inherit tiles debug useXdgDir;
  };

  self = common.overrideAttrs (common: rec {
    pname = common.pname + "-git";
    inherit version;

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      inherit rev sha256;
    };

    patches = [
      # Unconditionally look for translation files in $out/share/locale
      ./locale-path-git.patch
    ];

    makeFlags = common.makeFlags ++ [
      "VERSION=git-${version}-${lib.substring 0 8 src.rev}"
    ];

    meta = common.meta // {
      maintainers = with lib.maintainers; common.meta.maintainers ++ [ rardiol ];
    };
  });
in

attachPkgs pkgs self
