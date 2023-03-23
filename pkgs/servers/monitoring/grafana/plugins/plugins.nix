{ callPackage }:
{
  inherit callPackage;

  grafanaPlugin = callPackage ./grafana-plugin.nix { };

  doitintl-bigquery-datasource = callPackage ./doitintl-bigquery-datasource { };
  grafadruid-druid-datasource = callPackage ./grafadruid-druid-datasource { };
  grafana-clock-panel = callPackage ./grafana-clock-panel { };
  grafana-piechart-panel = callPackage ./grafana-piechart-panel { };
  grafana-polystat-panel = callPackage ./grafana-polystat-panel { };
  grafana-worldmap-panel = callPackage ./grafana-worldmap-panel { };
  redis-app = callPackage ./redis-app { };
  redis-datasource = callPackage ./redis-datasource { };
}
