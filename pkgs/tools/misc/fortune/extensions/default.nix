{ pkgs, ... }:

with pkgs;

{
  blag-fortune = callPackage ./blag-fortune.nix {};
}
