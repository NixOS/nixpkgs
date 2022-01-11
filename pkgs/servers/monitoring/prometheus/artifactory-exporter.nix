{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "artifactory_exporter";
  version = "1.9.1";
  rev = "v${version}";

  src = fetchFromGitHub {
    owner = "peimanja";
    repo = pname;
    rev = rev;
    sha256 = "1m68isplrs3zvkg0mans9bgablsif6264x3w475bpnhf68r87v1q";
  };

  vendorSha256 = "0acwgb0h89parkx75jp057m2hrqyd95vr2zcfqnxbnyy98gxip73";

  subPackages = [ "." ];

  ldflags = [
    "-s" "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${rev}"
    "-X github.com/prometheus/common/version.Branch=master"
    "-X github.com/prometheus/common/version.BuildDate=19700101-00:00:00"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) artifactory; };

  meta = with lib; {
    description = "JFrog Artifactory Prometheus Exporter";
    homepage = "https://github.com/peimanja/artifactory_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ lbpdt ];
  };
}
