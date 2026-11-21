{
  lib,
  lld,
  fetchFromGitHub,
  rustPlatform,
}:
let
  mkIrohPackage =
    {
      name,
      cargoFeatures ? [ ],
    }:
    rustPlatform.buildRustPackage rec {
      pname = name;
      version = "1.5.0";

      src = fetchFromGitHub {
        owner = "n0-computer";
        repo = "iroh";
        rev = "v${version}";
        hash = "sha256-K1NOFwrnTaoFUp26M1YNjs75l6KorNWO2JLWZ6+5ZjU=";
      };

      cargoHash = "sha256-FucLDbvw1k7ycUjetmJ7hH7317rJUBt5bYpQGoDQ86A=";

      buildFeatures = cargoFeatures;
      cargoBuildFlags = [
        "--bin"
        name
      ];

      nativeBuildInputs = [
        lld
      ];

      # Some tests require network access which is not available in nix build sandbox.
      doCheck = false;

      meta = {
        description = "Efficient IPFS for the whole world right now";
        homepage = "https://iroh.computer";
        license =
          with lib.licenses;
          OR [
            asl20
            mit
          ];
        maintainers = with lib.maintainers; [
          andreashgk
        ];
        mainProgram = name;
      };
    };
in
{
  iroh-dns-server = mkIrohPackage {
    name = "iroh-dns-server";
  };

  iroh-relay = mkIrohPackage {
    name = "iroh-relay";
    cargoFeatures = [ "server" ];
  };
}
