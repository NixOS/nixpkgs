{ lib, buildGoModule, fetchFromGitHub, testers, prometheus-pushgateway }:

buildGoModule rec {
  pname = "pushgateway";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "pushgateway";
    rev = "v${version}";
    sha256 = "sha256-IwSzxpIBXIsOllAd0faP+uzpYZ8HcWJQBOgYZj9SZHM=";
  };

  vendorHash = "sha256-xpbGavt0gzOVZMHVdPtZ+rRVbovJ4xaqaAmYVipLzSs=";

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
  };
}
