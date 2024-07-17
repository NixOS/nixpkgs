{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "collectd-exporter";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "collectd_exporter";
    rev = "v${version}";
    sha256 = "sha256-8oibunEHPtNdbhVgF3CL6D/xE7bR8hee6+D2IJMzaqY=";
  };

  vendorHash = "sha256-fQO2fiotqv18xewXVyh6sA4zx5ZNUR6mCebYenryrKI=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) collectd;
  };

  meta = with lib; {
    description = "Relay server for exporting metrics from collectd to Prometheus";
    mainProgram = "collectd_exporter";
    homepage = "https://github.com/prometheus/collectd_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}
