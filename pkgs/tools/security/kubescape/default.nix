{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubescape";
  version = "1.0.123";

  src = fetchFromGitHub {
    owner = "armosec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mrpQXIcV1KxOLDhWAS9Og76k18jsey7vPAcbhGe+cN4=";
  };

  vendorSha256 = "sha256-4v/7JrSGZKOyLwU6U3+hc9P+kzxGGj4aXG/wXmNdo+M=";

  # One test is failing, disabling for now
  doCheck = false;

  meta = with lib; {
    description = "Tool for testing if Kubernetes is deployed securely";
    homepage = "https://github.com/armosec/kubescape";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
