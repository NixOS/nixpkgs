{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "collectd-exporter";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "collectd_exporter";
    rev = "v${version}";
    sha256 = "sha256-MxgHJ9+e94ReY/8ISPfGEX9Z9ZHDyNsV0AqlPfsjXvc=";
  };

  vendorHash = "sha256-kr8mHprIfXc/Yj/w2UKBkqIYZHmWtBLjqYDvKSXlozQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) collectd; };

  meta = with lib; {
    description = "Relay server for exporting metrics from collectd to Prometheus";
    mainProgram = "collectd_exporter";
    homepage = "https://github.com/prometheus/collectd_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}
