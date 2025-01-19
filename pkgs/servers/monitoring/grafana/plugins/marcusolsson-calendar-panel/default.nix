{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "marcusolsson-calendar-panel";
  version = "3.7.0";
  zipHash = "sha256-O8EvkS+lWq2qaIj1HJzPagRGhrEENvY1YDBusvUejM0=";
  meta = {
    description = "Calendar Panel is a Grafana plugin that displays events from various data sources.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
