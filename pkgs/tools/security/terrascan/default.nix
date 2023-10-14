{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terrascan";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "accurics";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2jIdKBNn3Ajvq+fQ1OuQ0VB8+S0QYwLZnJMlGqZ7WtE=";
  };

  vendorHash = "sha256-PH94le8IwVuinlRsk84HGSxhBSJTTJDrou7nfD1J1JM=";

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
