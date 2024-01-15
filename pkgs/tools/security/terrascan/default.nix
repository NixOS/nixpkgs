{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terrascan";
  version = "1.18.11";

  src = fetchFromGitHub {
    owner = "accurics";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BICXMSkfGDXOqBH+4UlJmqkUSV+oZa1wg7c20EtJ3WI=";
  };

  vendorHash = "sha256-9zD81p/UjH43B0aeqlItP9vrGMaT/zhVYv60ot153Gc=";

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
