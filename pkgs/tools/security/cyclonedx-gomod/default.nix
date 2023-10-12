{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cyclonedx-gomod";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JczDfNBYT/Ap2lDucEvuT8NAwuQgmavOUvtznI6Q+Zc=";
  };

  vendorHash = "sha256-5Mn+f+oVwbn2qGaZct5+9f6tOBXfsB/I72yD7fHUrC8=";

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
