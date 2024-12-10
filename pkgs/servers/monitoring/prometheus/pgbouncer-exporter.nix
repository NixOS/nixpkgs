{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgbouncer-exporter";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "pgbouncer_exporter";
    rev = "v${version}";
    hash = "sha256-fKoyRHYLwVefsZ014eazVCD5B9eV8/CUkuHE4mbUqVo=";
  };

  vendorHash = "sha256-IxmxfF9WsF0Hbym4G0UecyW8hAvucoaCFUE1kXUljJs=";

  meta = with lib; {
    description = "Prometheus exporter for PgBouncer";
    mainProgram = "pgbouncer_exporter";
    homepage = "https://github.com/prometheus-community/pgbouncer_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.linux;
  };
}
