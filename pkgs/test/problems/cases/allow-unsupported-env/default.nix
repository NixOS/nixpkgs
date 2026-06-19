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
  meta.maintainers = [ "hello" ];
  meta.description = "Some package";
  meta.problems.jetsonOnly = {
    kind = "unsupported";
    message = "Only Xavier and Orin Jetson devices are supported.";
  };
}
