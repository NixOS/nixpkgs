{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "artifactory_exporter";
  version = "1.10.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    owner = "peimanja";
    repo = pname;
    rev = rev;
    hash = "sha256-Yzdh9xpgPLbN9J5oBvrrPuVMTq2F3mpE544sAo7gmng=";
  };

  vendorHash = "sha256-5yzBKgjJCv4tgdBS6XmZUq1ebbka0LOuv6BARWO7kQg=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${rev}"
    "-X github.com/prometheus/common/version.Branch=master"
    "-X github.com/prometheus/common/version.BuildDate=19700101-00:00:00"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) artifactory; };

  meta = with lib; {
    description = "JFrog Artifactory Prometheus Exporter";
    homepage = "https://github.com/peimanja/artifactory_exporter";
    changelog = "https://github.com/peimanja/artifactory_exporter/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lbpdt ];
  };
}
