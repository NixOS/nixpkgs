{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nginxlog_exporter";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "martin-helmich";
    repo = "prometheus-nginxlog-exporter";
    rev = "v${version}";
    sha256 = "sha256-UkXrVHHHZ9mEgsMUcHu+wI6NZFw4h3X4atDBjpBcz8E=";
  };

  vendorHash = "sha256-RzqfmP1d3zqageiGSr+CxSJQxAXmOKRCwj/7KO2f3EE=";

  subPackages = [ "." ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nginxlog; };

  meta = with lib; {
    description = "Export metrics from Nginx access log files to Prometheus";
    mainProgram = "prometheus-nginxlog-exporter";
    homepage = "https://github.com/martin-helmich/prometheus-nginxlog-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmahut ];
  };
}
