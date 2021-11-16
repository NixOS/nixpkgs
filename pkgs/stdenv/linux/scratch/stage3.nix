# Stage 2 is to natively compile seeds using the native-cross hybrid seeds.
{ from, to, nixpkgs }:
stage2:
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
      bootstrapFiles = {
        busybox = "${stage2.build}/on-server/busybox";
        bootstrapTools = "${stage2.build}/on-server/bootstrap-tools.tar.xz";
      };
    };
  }
