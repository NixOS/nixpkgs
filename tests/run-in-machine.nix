{ nixpkgs ? ../../nixpkgs
, services ? ../../services
, system ? builtins.currentSystem
}:

with import ../lib/testing.nix { inherit nixpkgs services system; };

runInMachine {
  drv = (import nixpkgs { }).aterm;
  machine = { config, pkgs, ... }: { services.sshd.enable = true; };
}
