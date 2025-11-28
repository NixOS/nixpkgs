{
  lib,
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
      version = "0.93.2";

      src = fetchFromGitHub {
        owner = "n0-computer";
        repo = "iroh";
        rev = "v${version}";
        hash = "sha256-IYuOo4dfTC7IfMkwFyjqFmOYjx87i84+ydyNxnSAfk4=";
      };

      cargoHash = "sha256-aR78AKfXRAePnOVO/Krx1WGcQgOIz3d+GDwfAoM10UQ=";

      buildFeatures = cargoFeatures;
      cargoBuildFlags = [
        "--bin"
        name
      ];

      # Some tests require network access which is not available in nix build sandbox.
      doCheck = false;

      meta = with lib; {
        description = "Efficient IPFS for the whole world right now";
        homepage = "https://iroh.computer";
        license = with licenses; [
          asl20
          mit
        ];
        maintainers = with maintainers; [
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
