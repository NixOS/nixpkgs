{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubemq-community";
  version = "2.2.12";
  src = fetchFromGitHub {
    owner = "kubemq-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "06n3avcqknqzf9y03xqcsg36pwcha29j2psp9xsnir7hrx66zww8";
  };

  CGO_ENABLED=0;

  ldflags=[ "-w" "-s" "-X main.version=${version}" ];

  doCheck = false;  # grpc tests are flaky

  vendorSha256 = "1sh0dzz8z065964k2gzkzw9p3db3rcf6mv901zym0wqm4p71045w";

  meta = {
    homepage = "https://github.com/kubemq-io/kubemq-community";
    description = "KubeMQ Community is the open-source version of KubeMQ, the Kubernetes native message broker.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ brianmcgee ];
  };
}
