{ nixpkgs }:
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = [ ];
    config = {
      problems.handlers = {
        "a"."maintainerless" = "warn";
        "a"."deprecated" = "warn";
        "a"."removal" = "warn";
      };
    };
  };
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "a";
  version = "0";
  meta.maintainers = [ ];
  meta.problems = {
    removal.message = "Package to be removed.";
    deprecated.message = "Package will be deprecated";
  };
}
