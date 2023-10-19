{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "statsd_exporter";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "statsd_exporter";
    rev = "v${version}";
    hash = "sha256-I0/UX4Tpbd2cfsMQQ3gAGfJ3Bgr+JxRARNmV2v2mLeM=";
  };

  vendorHash = "sha256-cTAjOCP0qWMIKa0xGSK7Id+Oqz3ompDlwAqwub9oNWI=";

  meta = with lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = "https://github.com/prometheus/statsd_exporter";
    changelog = "https://github.com/prometheus/statsd_exporter/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ivan ];
  };
}
