{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terrascan";
  version = "1.18.12";

  src = fetchFromGitHub {
    owner = "accurics";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-NTk/tCIArucJ12RR173bQ/VoP74oROYwmMrQizE+5iU=";
  };

  vendorHash = "sha256-Hk7dkhb1GiCY9CkKZ1dMQc+s97VRUli7WAoneJVNK08=";

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
    changelog = "https://github.com/tenable/terrascan/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
