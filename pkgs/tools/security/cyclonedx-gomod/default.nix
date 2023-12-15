{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cyclonedx-gomod";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-whAHZDUQBJaYu+OZiqcYzWxOru1GXDQ4FMDCj+ngCDs=";
  };

  vendorHash = "sha256-FpsZonGJSzbAsnM00qq/qiTJLUN4q08dR+6rhTKvX0I=";

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
