{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "redis-explorer-app";
  version = "2.1.1";
  zipHash = "sha256-t5L9XURNcswDbZWSmehs/JYU7NoEwhX1If7ghbi509g=";
  meta = {
    description = "Redis Explorer plugin for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ azahi ];
    platforms = lib.platforms.unix;
  };
}
