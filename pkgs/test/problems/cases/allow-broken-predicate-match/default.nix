{ nixpkgs }:
let
  lib = pkgs.lib;
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = [ ];
    config = {
      allowBrokenPredicate = attrs: lib.getName attrs == "a";
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
