{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terrascan";
  version = "1.19.9";

  src = fetchFromGitHub {
    owner = "accurics";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4XIhmUUOSROwEPSB+DcMOfG5+q/pmWkVUwKGrWVcNtM=";
  };

  vendorHash = "sha256-yQien8v7Ru+JWLou9QfyKZAR2ENMHO2aF2vzuWyQcjY=";

  # Tests want to download a vulnerable Terraform project
  doCheck = false;

  meta = with lib; {
    description = "Detect compliance and security violations across Infrastructure";
    mainProgram = "terrascan";
    longDescription = ''
      Detect compliance and security violations across Infrastructure as Code to
      mitigate risk before provisioning cloud native infrastructure. It contains
      500+ polices and support for Terraform and Kubernetes.
    '';
    homepage = "https://github.com/accurics/terrascan";
    changelog = "https://github.com/tenable/terrascan/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
