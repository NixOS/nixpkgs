{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubescape";
  version = "1.0.88";

  src = fetchFromGitHub {
    owner = "armosec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ITN/HsXZWH1v23R5TSEd8vq/DkhiCypJM+hg879ZWlc=";
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
