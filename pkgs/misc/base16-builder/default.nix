{ stdenv, pkgs }:

let
  # node-packages*.nix generated via:
  #
  # % node2nix --input node-packages.json \
  #            --output node-packages-generated.nix \
  #            --composition node-packages.nix \
  #            --node-env ./../../development/node-packages/node-env.nix \
  #            --pkg-name nodejs-6_x
  #
  nodePackages = import ./node-packages.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
in nodePackages.base16-builder
