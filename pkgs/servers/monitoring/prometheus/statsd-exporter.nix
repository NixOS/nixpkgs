{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "statsd_exporter";
  version = "0.22.7";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "statsd_exporter";
    sha256 = "sha256-hkzgLjxFczqKKJHdVfCKPqMXVFShlS5lZoX8NA27u90=";
  };

  vendorSha256 = "sha256-/qc3Ui18uSDfHsXiNA63+uPSfxShz7cs3kv0rQPgCok=";

  meta = with lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = "https://github.com/prometheus/statsd_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ivan ];
    platforms = platforms.unix;
  };
}
