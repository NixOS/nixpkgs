{ lib, buildGoModule, fetchFromGitHub, testers, prometheus-pushgateway }:

buildGoModule rec {
  pname = "pushgateway";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "pushgateway";
    rev = "v${version}";
    sha256 = "sha256-UnkSv0ZGNFqEQX+QeCySN5XeGbM2hCJGgWxry5I+3tg=";
  };

  vendorSha256 = "sha256-wEKk7Jrf14oJzP6MSRJidOUUgAbPFoBOmqPrXJg86FI=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${version}"
    "-X github.com/prometheus/common/version.Branch=${version}"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=19700101-00:00:00"
  ];

  passthru.tests.version = testers.testVersion {
    package = prometheus-pushgateway;
  };

  meta = with lib; {
    description = "Allows ephemeral and batch jobs to expose metrics to Prometheus";
    homepage = "https://github.com/prometheus/pushgateway";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
