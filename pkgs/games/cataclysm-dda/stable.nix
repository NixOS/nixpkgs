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

  self = common.overrideAttrs (
    finalAttrs: common: {
      version = "0.I";

      src = fetchFromGitHub {
        owner = "CleverRaven";
        repo = "Cataclysm-DDA";
        tag = "${finalAttrs.version}";
        hash = "sha256-nzHqN6WjhuR1IoJ50XryI3B1fUQPepzGMaDJzudUaVI=";
      };

      meta = {
        inherit (common.meta)
          description
          mainProgram
          longDescription
          homepage
          license
          maintainers
          platforms
          ;
        changelog = "https://github.com/CleverRaven/Cataclysm-DDA/blob/${finalAttrs.version}/data/changelog.txt";
      };
    }
  );
in

attachPkgs pkgs self
