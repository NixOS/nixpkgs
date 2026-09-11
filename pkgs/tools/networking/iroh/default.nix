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
      version = "1.1.0";

      src = fetchFromGitHub {
        owner = "n0-computer";
        repo = "iroh";
        rev = "v${version}";
        hash = "sha256-inEGT8MuNRlXwrFiQpFPybSOF+GkIJxMp2nv81xHhBI=";
      };

      cargoHash = "sha256-/1G+Rv/iNBkJL7NEioqozBoCUqYGPcSfhVCCTj8qfL8=";

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
