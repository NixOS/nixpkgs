{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terrascan";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "accurics";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HV9WOJ8bWu8Uk1tXMZWqvo3ZvFiWLMGKmw6HzHBxSBY=";
  };

  vendorSha256 = "sha256-MB3/iIStqNBM9YnNaRpV4hbs1gZzWm+7B+qHHm0kOmU=";

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
