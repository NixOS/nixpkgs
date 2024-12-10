{
  pkgs ? import ../../../.. { },
}:
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.nodePackages.node2nix
    pkgs.nix-prefetch-github
  ];
}
