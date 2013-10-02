{ nixpkgs ? <nixpkgs>
, system ? builtins.currentSystem
}:

with import ../lib/testing.nix { inherit system; };

runInMachine {
  drv = (import nixpkgs { inherit system; }).aterm;
  machine = { config, pkgs, ... }: { services.sshd.enable = true; };
}
