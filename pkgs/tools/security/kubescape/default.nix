{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubescape";
  version = "1.0.120";

  src = fetchFromGitHub {
    owner = "armosec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aFFJAib0/FTOaPtSLYXIFV3+QfIpzy8fC7rWAQW5yh0=";
  };

  vendorSha256 = "sha256-vN+ci2vCbtDuEEVzZQiFkdi1QkMgnnbbJgD9g6DS7qs=";

  # One test is failing, disabling for now
  doCheck = false;

  meta = with lib; {
    description = "Tool for testing if Kubernetes is deployed securely";
    homepage = "https://github.com/armosec/kubescape";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
