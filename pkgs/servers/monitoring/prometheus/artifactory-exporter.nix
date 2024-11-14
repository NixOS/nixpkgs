{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "artifactory_exporter";
  version = "1.14.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    owner = "peimanja";
    repo = pname;
    rev = rev;
    hash = "sha256-+CCUSI7Rh9fENzsg7rpI01Cm++kafd1nGgpyFRt20Ug=";
  };

  vendorHash = "sha256-CQ7JvXcutj63UzaYk/jbmd9G2whN48Xv1PCllaI9Nuo=";

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
    mainProgram = "artifactory_exporter";
    homepage = "https://github.com/peimanja/artifactory_exporter";
    changelog = "https://github.com/peimanja/artifactory_exporter/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lbpdt ];
  };
}
