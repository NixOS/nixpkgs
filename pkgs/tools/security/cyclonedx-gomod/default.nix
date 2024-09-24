{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cyclonedx-gomod";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-gomod";
    rev = "refs/tags/v${version}";
    hash = "sha256-RM8ZH1mO+72ptoU7YKXlCZAyDhYZ7MFXyDYrqBQwsDI=";
  };

  vendorHash = "sha256-1ibMneSOYs5C6Ul8m/rVXVFBJHZrH1D5eWRwVVJ6a+A=";

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
