{ stdenv
, pkgs
, lib
, nodejs-14_x
}:

let
  nodejs = nodejs-14_x;

  nodePackages = import ./node-packages.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  ethercalc = lib.head (lib.attrValues nodePackages);

  combined = ethercalc.override {
    meta = with lib; {
      description = "Online collaborative spreadsheet";
      license = with licenses; [ cpal10 artistic2 mit asl20 cc0 mpl20 ];
      homepage = "https://github.com/audreyt/ethercalc";
      maintainers = with maintainers; [ iblech ];
      platforms = platforms.unix;
    };
  };
in
  combined
