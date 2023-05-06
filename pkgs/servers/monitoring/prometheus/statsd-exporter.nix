{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "statsd_exporter";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "statsd_exporter";
    rev = "v${version}";
    hash = "sha256-JbRkLRXTQo40wBynfG6BRR4+yPqy7VLJ33vsjus5okg=";
  };

  vendorHash = "sha256-YzcgEQ1S2qn7v2SVSBiodprtc+D4cSZOFBJwpq3jz8Y=";

  meta = with lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = "https://github.com/prometheus/statsd_exporter";
    changelog = "https://github.com/prometheus/statsd_exporter/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ivan ];
    platforms = platforms.unix;
  };
}
