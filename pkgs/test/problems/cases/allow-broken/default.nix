{ nixpkgs }:
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = [ ];
    config = {
      allowBroken = true;
    };
  };
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "a";
  version = "0";
  meta.maintainers = [ "hello" ];
  meta.description = "Some package";
  meta.broken = true;
}
