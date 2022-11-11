{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubemq-community";
  version = "2.3.4";
  src = fetchFromGitHub {
    owner = "kubemq-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+HJpjKMSndcV+xQJM+FesdtoUSGHnpILQFuf3sbxBY0=";
  };

  CGO_ENABLED=0;

  ldflags=[ "-w" "-s" "-X main.version=${version}" ];

  doCheck = false;  # grpc tests are flaky

  vendorSha256 = "sha256-mie+Akfsn+vjoxYnI23Zxk0OTFbMf51BDbJk2c0U7iU=";

  meta = {
    homepage = "https://github.com/kubemq-io/kubemq-community";
    description = "KubeMQ Community is the open-source version of KubeMQ, the Kubernetes native message broker.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ brianmcgee ];
  };
}
