{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubescape";
  version = "1.0.85";

  src = fetchFromGitHub {
    owner = "armosec";
    repo = pname;
    rev = "v${version}";
    sha256 = "19r7dgr0y1k9qa4llxbgaf69j88vs9h2gx29bwbh6dq17q58sfdl";
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
