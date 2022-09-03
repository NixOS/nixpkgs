{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "influxdb_exporter";
  version = "0.10.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "influxdb_exporter";
    sha256 = "sha256-AK1vlaYd2/+8/1rpzT1lKvTgybgxoL7gFqZIadfEUQY=";
  };

  vendorSha256 = "sha256-xTxSKeCTkWKl70wm+5htFncMW6SdzbA4zW9tjKE9vDM=";

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
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
