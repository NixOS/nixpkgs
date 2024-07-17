{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgbouncer-exporter";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "pgbouncer_exporter";
    rev = "v${version}";
    hash = "sha256-QnA9H4qedCPZKqJQ1I2OJO42mCWcWqYxLmeF3+JXzTw=";
  };

  vendorHash = "sha256-NYiVW+CNrxFrEUl1nsTeNNgy7SmTYgqs1d50rCvyBcw=";

  meta = with lib; {
    description = "Prometheus exporter for PgBouncer";
    mainProgram = "pgbouncer_exporter";
    homepage = "https://github.com/prometheus-community/pgbouncer_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.linux;
  };
}
