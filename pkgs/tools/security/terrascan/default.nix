{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "terrascan";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "accurics";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mPd4HsWbPUNJTUNjQ5zQztoXZy2b9iLksdGKAjp0A58=";
  };

  vendorSha256 = "sha256-eNQTJHqOCOTAPO+vil6rkV9bNWZIdXxGQPE4IpETFtA=";

  # tests want to download a vulnerable Terraform project
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
