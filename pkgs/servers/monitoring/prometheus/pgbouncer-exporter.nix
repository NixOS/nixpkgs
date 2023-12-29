{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgbouncer-exporter";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "pgbouncer_exporter";
    rev = "v${version}";
    hash = "sha256-2N8FaGk6AU39j4q22B2Om5E7BeR7iw9drl3PTOBO2kg=";
  };

  vendorHash = "sha256-2aaUlOokqYkjMpcM12mU+O+N09/mDPlIrJ4Z1iXJAyk=";

  meta = with lib; {
    description = "Prometheus exporter for PgBouncer";
    homepage = "https://github.com/prometheus-community/pgbouncer_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.linux;
  };
}
