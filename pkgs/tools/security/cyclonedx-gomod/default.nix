{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cyclonedx-gomod";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3YHlh7edRWU8plAJh96RDkrC9YUQjvV4vNGOxmbS0sA=";
  };

  vendorHash = "sha256-0Fx9pOofcY5rpX6DU2xPeg7xEZ8ows/DWwyV5B7LHGY=";

  # Tests require network access and cyclonedx executable
  doCheck = false;

  meta = with lib; {
    description = "Tool to create CycloneDX Software Bill of Materials (SBOM) from Go modules";
    homepage = "https://github.com/CycloneDX/cyclonedx-gomod";
    changelog = "https://github.com/CycloneDX/cyclonedx-gomod/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "cyclonedx-gomod";
  };
}
