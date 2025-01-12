{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cyclonedx-gomod";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-gomod";
    tag = "v${version}";
    hash = "sha256-iD8mDqQl18ufJBoRkpqYZc+I259HfnFNp29guvBtGDk=";
  };

  vendorHash = "sha256-Yw+lci0vBDWeJVjOX83LKNb7afcsIK/AC5GZPRSzcdo=";

  ldflags = [
    "-w"
    "-s"
  ];

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
