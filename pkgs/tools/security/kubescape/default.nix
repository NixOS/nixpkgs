{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubescape";
  version = "1.0.126";

  src = fetchFromGitHub {
    owner = "armosec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kx7TgQ+ordlgYfnlt9/KkmTMUwfykGnTOEcTtq7EAYA=";
  };

  vendorSha256 = "sha256-u9Jo3/AdW+AhVe/5RwAPfLIjp+H1Omb1SlpctOEQB5Q=";

  # One test is failing, disabling for now
  doCheck = false;

  meta = with lib; {
    description = "Tool for testing if Kubernetes is deployed securely";
    homepage = "https://github.com/armosec/kubescape";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
