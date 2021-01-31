{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "artifactory_exporter";
  version = "1.9.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    owner = "peimanja";
    repo = pname;
    rev = rev;
    sha256 = "1zmkajg48i40jm624p2h03bwg7w28682yfcgk42ig3d50p8xwqc3";
  };

  vendorSha256 = "1594bpfwhbjgayf4aacs7rfjxm4cnqz8iak8kpm1xzsm1cx1il17";

  subPackages = [ "." ];

  buildFlagsArray = ''
     -ldflags=
      -s -w
      -X github.com/prometheus/common/version.Version=${version}
      -X github.com/prometheus/common/version.Revision=${rev}
      -X github.com/prometheus/common/version.Branch=master
      -X github.com/prometheus/common/version.BuildDate=19700101-00:00:00
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) artifactory; };

  meta = with lib; {
    description = "JFrog Artifactory Prometheus Exporter";
    homepage = "https://github.com/peimanja/artifactory_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ lbpdt ];
  };
}
