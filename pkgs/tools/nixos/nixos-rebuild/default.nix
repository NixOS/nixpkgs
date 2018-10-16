{ substituteAll, nix }:
let
  fallback = import ./nix-fallback-paths.nix;
in
  substituteAll {
    name = "nixos-rebuild";
    dir = "bin";
    isExecutable = true;
    src = ./nixos-rebuild.sh;
    nix = nix.out;
    nix_x86_64_linux = fallback.x86_64-linux;
    nix_i686_linux = fallback.i686-linux;
  }
