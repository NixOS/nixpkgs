{ nixpkgs }:
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = [ ];
    config = {
      problems.handlers = {
        "a"."deprecated" = "error";
        "a"."removal" = "error";
        "a"."maintainerless" = "error";
      };
    };
  };
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "a";
  version = "0";
  meta.problems = {
    deprecated.message = "Package is deprecated and replaced by b";
    removal.message = "Package will be removed.";
  };
  meta.maintainers = [ ];
}
