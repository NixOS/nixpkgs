{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgbouncer-exporter";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "pgbouncer_exporter";
    rev = "v${version}";
    hash = "sha256-YvkD6X2aSXeOW7O5RqAVM1Fo6KE8OCh0+QzgoW8QAVg=";
  };

  vendorHash = "sha256-IBIJWA/arARPV0ErAQdGJXbPAaryCN22mHwKL08M8QA=";

  meta = {
    description = "Prometheus exporter for PgBouncer";
    mainProgram = "pgbouncer_exporter";
    homepage = "https://github.com/prometheus-community/pgbouncer_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _1000101 ];
    platforms = lib.platforms.linux;
  };
}
