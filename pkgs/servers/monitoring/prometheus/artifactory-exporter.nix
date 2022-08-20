{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "artifactory_exporter";
  version = "1.9.4";
  rev = "v${version}";

  src = fetchFromGitHub {
    owner = "peimanja";
    repo = pname;
    rev = rev;
    sha256 = "sha256-vrbuKWoKfDrgJEOYsncwJZ8lyAfanbV8jKQDVCZY2Sg=";
  };

  vendorSha256 = "sha256-wKBSAZSE/lSUbkHkyBEkO0wvkrK6fKxXIjF6G+ILqHM=";

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
