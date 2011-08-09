{ nixpkgs ? ../../nixpkgs
, system ? builtins.currentSystem
}:

with import ../lib/testing.nix { inherit nixpkgs system; };

runInMachine {
  drv = (import nixpkgs { }).aterm;
  machine = { config, pkgs, ... }: { services.sshd.enable = true; };
}
