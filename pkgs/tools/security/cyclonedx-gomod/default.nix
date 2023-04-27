{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cyclonedx-gomod";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GCRLOfrL1jFExGb5DbJa8s7RQv8Wn81TGktShZqeC54=";
  };

  vendorHash = "sha256-gFewqutvkFc/CVpBD3ORGcfiG5UNh5tQ1ElHpM3g5+I=";

  # Tests require network access and cyclonedx executable
  doCheck = false;

  meta = with lib; {
    description = "Tool to create CycloneDX Software Bill of Materials (SBOM) from Go modules";
    homepage = "https://github.com/CycloneDX/cyclonedx-gomod";
    changelog = "https://github.com/CycloneDX/cyclonedx-gomod/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
