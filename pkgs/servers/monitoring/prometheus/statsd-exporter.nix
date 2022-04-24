{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "statsd_exporter";
  version = "0.22.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "statsd_exporter";
    sha256 = "sha256-pLzUbeSCMV0yr4gSR7m6NYrpm8ZhCPbwwZ5nQzy6lEM=";
  };

  vendorSha256 = "sha256-gBeeOxnVT0+x33VuwZhfjk3Fb8JHZdAzaDuFZlUfdgM=";

  meta = with lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = "https://github.com/prometheus/statsd_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ivan ];
    platforms = platforms.unix;
  };
}
