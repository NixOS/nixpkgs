{ pkgs ? import ../../../../.. { config = { }; overlays = [ ]; } }:

pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.nodePackages.node2nix
  ];
  src = pkgs.callPackage ./src.nix { };
}
