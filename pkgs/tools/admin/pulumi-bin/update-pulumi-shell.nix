{ nixpkgs ? import ../../../.. { } }:
with nixpkgs;
mkShell {
  packages = [
    pkgs.gh
  ];
}
