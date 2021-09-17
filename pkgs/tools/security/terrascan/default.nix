{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terrascan";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "accurics";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IF5BDe6XnOR7F/ajYBbMuFpIxUawgd/Oo2AthL5aeWE=";
  };

  vendorSha256 = "sha256-PZM8OWvjj8681/CWVE896f3vRHnkNeJj2w/aoOFZ9P0=";

  # Tests want to download a vulnerable Terraform project
  doCheck = false;

  meta = with lib; {
    description = "Detect compliance and security violations across Infrastructure";
    longDescription = ''
      Detect compliance and security violations across Infrastructure as Code to
      mitigate risk before provisioning cloud native infrastructure. It contains
      500+ polices and support for Terraform and Kubernetes.
    '';
    homepage = "https://github.com/accurics/terrascan";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
