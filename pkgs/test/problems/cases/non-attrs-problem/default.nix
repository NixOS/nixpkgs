{ nixpkgs }:
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = [ ];
    config = {
      checkMeta = true;
      problems.matchers = [
        {
          package = "a";
          handler = "error";
        }
      ];
    };
  };
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "a";
  version = "0";
  meta.problems.florp = true;
}
