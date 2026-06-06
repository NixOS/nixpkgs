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
    version = "0.I";

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      tag = "${version}";
      hash = "sha256-nzHqN6WjhuR1IoJ50XryI3B1fUQPepzGMaDJzudUaVI=";
    };

    meta = common.meta // {
      changelog = "https://github.com/CleverRaven/Cataclysm-DDA/blob/${version}/data/changelog.txt";
    };
  });
in

attachPkgs pkgs self
