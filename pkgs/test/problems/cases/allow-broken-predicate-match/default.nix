{ nixpkgs }:
let
  lib = pkgs.lib;
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = [ ];
    config = {
      problems.handlers.a.broken = "ignore";
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
