{ stdenv, pkgs }:

let
  nodePackages = import ./composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
in nodePackages.balena-cli.override {
  meta = nodePackages.balena-cli.meta // {
    maintainers = with stdenv.lib.maintainers; [ doronbehar ];
  };
  passthru.updateScript = ./update.sh;
}
