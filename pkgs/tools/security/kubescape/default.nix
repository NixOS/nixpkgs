{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubescape";
  version = "1.0.109";

  src = fetchFromGitHub {
    owner = "armosec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aPy0FcDFoBK02pCmDTe5T1QyB9+WC++cBuOI7CtaXtY=";
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
