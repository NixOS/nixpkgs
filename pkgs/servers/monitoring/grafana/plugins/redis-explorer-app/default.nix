{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "redis-explorer-app";
  version = "2.1.1";
  zipHash = "sha256-t5L9XURNcswDbZWSmehs/JYU7NoEwhX1If7ghbi509g=";
  meta = with lib; {
    description = "Redis Explorer plugin for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
  };
}
