{ callPackage }:
{
  inherit callPackage;

  grafanaPlugin = callPackage ./grafana-plugin.nix { };

  doitintl-bigquery-datasource = callPackage ./doitintl-bigquery-datasource { };
  grafadruid-druid-datasource = callPackage ./grafadruid-druid-datasource { };
<<<<<<< HEAD
  grafana-clickhouse-datasource = callPackage ./grafana-clickhouse-datasource { };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  grafana-clock-panel = callPackage ./grafana-clock-panel { };
  grafana-piechart-panel = callPackage ./grafana-piechart-panel { };
  grafana-polystat-panel = callPackage ./grafana-polystat-panel { };
  grafana-worldmap-panel = callPackage ./grafana-worldmap-panel { };
  redis-app = callPackage ./redis-app { };
  redis-datasource = callPackage ./redis-datasource { };
  redis-explorer-app = callPackage ./redis-explorer-app { };
}
