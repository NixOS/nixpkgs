# Stage 1 is to cross-compile seeds.
{ from, to, nixpkgs }:
let
  make-bootstrap-tools = import ../make-bootstrap-tools.nix;
in
  make-bootstrap-tools rec {
    stage = "stage1";
    localSystem = {
      system = from;
    };
    crossSystem = {
      system = to;
    };
    inherit nixpkgs;
    pkgs = nixpkgs {
      inherit localSystem crossSystem;
    };
  }
