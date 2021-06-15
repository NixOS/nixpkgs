{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "okteteo";
  version = "1.8.15";

  goPackagePath = "github.com/okteto/okteto";
  subPackages = ["."];

  buildFlagsArray = [
    "-tags=osusergo netgo"
    "-ldflags=-s -w -X ${goPackagePath}/pkg/config.VersionString=${version}"
  ];

  src = fetchFromGitHub {
    owner = "okteto";
    repo = "okteto";
    rev = version;
    sha256 = "0eFo0gYciLoHIebMRMqrOMMclG23D9mRoxCQIffvSP0=";
  };

  vendorSha256 = "5F/SXs5jqLfZXqXPO93KCfDneDcCZNzjhYJ4jqzkfuw=";

  meta = with lib; {
    description = "Build better applications by developing and testing your code directly in Kubernetes.";
    homepage = "https://github.com/okteto/okteto";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
  };
}
