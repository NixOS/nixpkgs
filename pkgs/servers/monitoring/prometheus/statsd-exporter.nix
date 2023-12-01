{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "statsd_exporter";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "statsd_exporter";
    rev = "v${version}";
    hash = "sha256-H5ckrDAs9gwQCkVe4TKF4yuqLh2S/+dPaaRH+5aoj+o=";
  };

  vendorHash = "sha256-LhPfOc83/IWkTk3C1DZggWngPJWobZFeCl4cum/aIQo=";

  meta = with lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = "https://github.com/prometheus/statsd_exporter";
    changelog = "https://github.com/prometheus/statsd_exporter/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ivan ];
  };
}
