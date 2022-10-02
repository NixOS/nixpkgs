{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubemq-community";
  version = "2.3.0";
  src = fetchFromGitHub {
    owner = "kubemq-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-E4X8srrfbOHV2XmjaXV25WilIjBGPjEGD6BqK7HreoQ=";
  };

  CGO_ENABLED=0;

  ldflags=[ "-w" "-s" "-X main.version=${version}" ];

  doCheck = false;  # grpc tests are flaky

  vendorSha256 = "sha256-kvQ5sPMudI75fVIWJkkwXpmVrJysvWcIgpgjyQh19W0=";

  meta = {
    homepage = "https://github.com/kubemq-io/kubemq-community";
    description = "KubeMQ Community is the open-source version of KubeMQ, the Kubernetes native message broker.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ brianmcgee ];
  };
}
