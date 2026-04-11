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
      version = "0.96.0";

      src = fetchFromGitHub {
        owner = "n0-computer";
        repo = "iroh";
        rev = "v${version}";
        hash = "sha256-J7FiKIBFUnTUJJwzwzfyk7+CK0UKlAPNFjVDDGlHMqM=";
      };

      cargoHash = "sha256-W8PVysQffGuxBIDpcZ77ujOQ5KBED6svwEXPeZpQmTc=";

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
        license = with lib.licenses; [
          asl20
          mit
        ];
        maintainers = with lib.maintainers; [
          andreashgk
          cameronfyfe
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
