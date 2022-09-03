{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubemq-community";
  version = "2.2.13";
  src = fetchFromGitHub {
    owner = "kubemq-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YeFSea6aCNH+v3AKqiG8BY4u7/enmOPlEybkz6RwU8w=";
  };

  CGO_ENABLED=0;

  ldflags=[ "-w" "-s" "-X main.version=${version}" ];

  doCheck = false;  # grpc tests are flaky

  vendorSha256 = "sha256-pRbYNR3z4KdA9pdthX8a3FZ0LNyvoT+PR+6OinDGF2g=";

  meta = {
    homepage = "https://github.com/kubemq-io/kubemq-community";
    description = "KubeMQ Community is the open-source version of KubeMQ, the Kubernetes native message broker.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ brianmcgee ];
  };
}
