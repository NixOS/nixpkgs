{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "statsd_exporter";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "statsd_exporter";
    rev = "v${version}";
    hash = "sha256-7atRLwucO09yN2odu0uNe7xrtKLq9kmy6JyI1y4Sww8=";
  };

  vendorHash = "sha256-H0f7bDnSddlabpRbMpk9tInlne2tI5J+MQ23mw1N71E=";

  meta = with lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = "https://github.com/prometheus/statsd_exporter";
    changelog = "https://github.com/prometheus/statsd_exporter/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ivan ];
    platforms = platforms.unix;
  };
}
