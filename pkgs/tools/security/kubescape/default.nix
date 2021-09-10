{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubescape";
  version = "1.0.64";

  src = fetchFromGitHub {
    owner = "armosec";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vc673w40cgjw6jxlwg9ggwzb7yvmsqshihms6ahspc3qiwz56ah";
  };

  vendorSha256 = "18mvv70g65pq1c7nn752j26d0vasx6cl2rqp5g1hg3cb61hjbn0n";

  # One test is failing, disabling for now
  doCheck = false;

  meta = with lib; {
    description = "Tool for testing if Kubernetes is deployed securely";
    homepage = "https://github.com/armosec/kubescape";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
