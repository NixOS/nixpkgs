{ nixpkgs }:
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = [ ];
    config = { };
  };
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "a";
  version = "0";
  meta.problems = {
    removal.message = "This package has been abandoned upstream and will be removed";
  };
}
