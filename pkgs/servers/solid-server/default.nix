{ stdenv, pkgs }:

let
  nodePackages = import ./node-packages.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages."@solid/community-server".override {
  pname = "community-solid-server";
}
