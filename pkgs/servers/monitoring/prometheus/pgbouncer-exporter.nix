{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgbouncer-exporter";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "pgbouncer_exporter";
    rev = "v${version}";
    hash = "sha256-cLCoEREGZ81a6CBcSyuQ4x4lDMusHoP7BB0MyPaTVJ8=";
  };

  vendorHash = "sha256-qAsmPMANBiswF2/+rCZnqFETD0snnPHQGUaVOXErLfc=";

  meta = {
    description = "Prometheus exporter for PgBouncer";
    mainProgram = "pgbouncer_exporter";
    homepage = "https://github.com/prometheus-community/pgbouncer_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _1000101 ];
    platforms = lib.platforms.linux;
  };
}
