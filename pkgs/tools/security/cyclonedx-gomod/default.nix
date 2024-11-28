{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cyclonedx-gomod";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-gomod";
    rev = "refs/tags/v${version}";
    hash = "sha256-s5kzyQPf29RZPnPtgFf4IVHnOtVZOtGSQqy1BNVVykQ=";
  };

  vendorHash = "sha256-Sz2NCznyD0tMuho9kr+U35I8bS/WK276nPdt83k1zfU=";

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
