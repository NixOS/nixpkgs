{ callPackage }:
{
  inherit callPackage;

  grafanaPlugin = callPackage ./grafana-plugin.nix { };

  doitintl-bigquery-datasource = callPackage ./doitintl-bigquery-datasource { };
  grafadruid-druid-datasource = callPackage ./grafadruid-druid-datasource { };
  grafana-clickhouse-datasource = callPackage ./grafana-clickhouse-datasource { };
  grafana-clock-panel = callPackage ./grafana-clock-panel { };
  grafana-oncall-app = callPackage ./grafana-oncall-app { };
  grafana-piechart-panel = callPackage ./grafana-piechart-panel { };
  grafana-polystat-panel = callPackage ./grafana-polystat-panel { };
  grafana-worldmap-panel = callPackage ./grafana-worldmap-panel { };
  redis-app = callPackage ./redis-app { };
  redis-datasource = callPackage ./redis-datasource { };
  redis-explorer-app = callPackage ./redis-explorer-app { };
}
