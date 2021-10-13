# Stage 2 is to natively compile seeds using the cross-compiled seeds.
{ from, to, nixpkgs }:
stage1:
let
  make-bootstrap-tools = import ../make-bootstrap-tools.nix;
in
  make-bootstrap-tools rec {
    localSystem = {
      system = to;
    };
    inherit nixpkgs;
    pkgs = nixpkgs {
      inherit localSystem;
      bootstrapTools = {
        busybox = "${stage1.build}/on-server/busybox";
        bootstrapTools = "${stage1.build}/on-server/bootstrap-tools.tar.xz";
      };
    };
  }
