# Usage: nix-build ./default.nix --argstr to powerpc64le-linux -A dist
{ from ? builtins.currentSystem, to, nixpkgs ? import ../../../.. }:
let
  args = { inherit from to nixpkgs; };
  stage1 = import ./stage1.nix args;
  stage2 = import ./stage2.nix args stage1;
  stage3 = import ./stage3.nix args stage2;
in
  stage3
