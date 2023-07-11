{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "influxdb_exporter";
  version = "0.11.4";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "influxdb_exporter";
    hash = "sha256-q6Pe7rw5BP1IUdokwlTqjiz2nB8+pC6u9al164EgAbM=";
  };

  vendorHash = "sha256-sU2jxmXuSN5D+btjzUU51WXWxmj+2Qqp28NQvEyIUbM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${rev}"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) influxdb; };

  meta = with lib; {
    description = "Prometheus exporter that accepts InfluxDB metrics";
    homepage = "https://github.com/prometheus/influxdb_exporter";
    changelog = "https://github.com/prometheus/influxdb_exporter/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
