pkgs:

let
  callPackage = pkgs.callPackage;
in {
  deliantra-server = callPackage ./deliantra-server.nix {};
  deliantra-arch = callPackage ./deliantra-arch.nix {};
  deliantra-maps = callPackage ./deliantra-maps.nix {};
  deliantra-data = callPackage ./deliantra-data.nix {};
}
