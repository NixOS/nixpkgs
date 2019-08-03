{ stdenv, pkgs }:

let
  # node-packages*.nix generated via:
  #
  # % node2nix --input node-packages.json \
  #            --output node-packages-generated.nix \
  #            --composition node-packages.nix \
  #            --node-env ./../../../development/node-packages/node-env.nix
  #
  nodePackages = import ./node-packages.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
in pkgs.lib.overrideDerivation nodePackages."@bitwarden/cli" (drv: {
  # This defaults to "node-_at_bitwarden_slash_cli-1.7.0"
  name = "bitwarden-cli-${drv.version}";
})
