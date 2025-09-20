{
  stdenv,
  pkgs,
  lib,
  nodejs_20,
}:

let
  nodejs = nodejs_20;

  nodePackages = import ./node-packages.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  ethercalc = lib.head (lib.attrValues nodePackages);

  combined = ethercalc.override {
    meta = {
      description = "Online collaborative spreadsheet";
      license = with lib.licenses; [
        cpal10
        artistic2
        mit
        asl20
        cc0
        mpl20
      ];
      homepage = "https://github.com/audreyt/ethercalc";
      maintainers = with lib.maintainers; [ iblech ];
      platforms = lib.platforms.unix;
    };
  };
in
combined
