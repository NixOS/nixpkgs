{ substituteAll
, runtimeShell
, coreutils
, gnused
, gnugrep
, jq
, nix
, lib
}:
let
  fallback = import ./../../../../nixos/modules/installer/tools/nix-fallback-paths.nix;
in
substituteAll {
  name = "nixos-rebuild";
  src = ./nixos-rebuild.sh;
  dir = "bin";
  isExecutable = true;
  inherit runtimeShell nix;
  nix_x86_64_linux = fallback.x86_64-linux;
  nix_i686_linux = fallback.i686-linux;
  nix_aarch64_linux = fallback.aarch64-linux;
  path = lib.makeBinPath [ coreutils jq gnused gnugrep ];
}
