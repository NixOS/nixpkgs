{ callPackage }:
{
  inherit callPackage;

  grafanaPlugin = callPackage ./grafana-plugin.nix { };

  bsull-console-datasource = callPackage ./bsull-console-datasource { };
  doitintl-bigquery-datasource = callPackage ./doitintl-bigquery-datasource { };
  fetzerch-sunandmoon-datasource = callPackage ./fetzerch-sunandmoon-datasource { };
  frser-sqlite-datasource = callPackage ./frser-sqlite-datasource { };
  grafadruid-druid-datasource = callPackage ./grafadruid-druid-datasource { };
  grafana-clickhouse-datasource = callPackage ./grafana-clickhouse-datasource { };
  grafana-clock-panel = callPackage ./grafana-clock-panel { };
  grafana-discourse-datasource = callPackage ./grafana-discourse-datasource { };
  grafana-github-datasource = callPackage ./grafana-github-datasource { };
  grafana-googlesheets-datasource = callPackage ./grafana-googlesheets-datasource { };
  grafana-mqtt-datasource = callPackage ./grafana-mqtt-datasource { };
  grafana-oncall-app = callPackage ./grafana-oncall-app { };
  grafana-opensearch-datasource = callPackage ./grafana-opensearch-datasource { };
  grafana-piechart-panel = callPackage ./grafana-piechart-panel { };
  grafana-polystat-panel = callPackage ./grafana-polystat-panel { };
  grafana-worldmap-panel = callPackage ./grafana-worldmap-panel { };
  marcusolsson-calendar-panel = callPackage ./marcusolsson-calendar-panel { };
  marcusolsson-csv-datasource = callPackage ./marcusolsson-csv-datasource { };
  marcusolsson-dynamictext-panel = callPackage ./marcusolsson-dynamictext-panel { };
  marcusolsson-json-datasource = callPackage ./marcusolsson-json-datasource { };
  redis-app = callPackage ./redis-app { };
  redis-datasource = callPackage ./redis-datasource { };
  redis-explorer-app = callPackage ./redis-explorer-app { };
  ventura-psychrometric-panel = callPackage ./ventura-psychrometric-panel { };
  volkovlabs-echarts-panel = callPackage ./volkovlabs-echarts-panel { };
  volkovlabs-form-panel = callPackage ./volkovlabs-form-panel { };
  volkovlabs-rss-datasource = callPackage ./volkovlabs-rss-datasource { };
  volkovlabs-variable-panel = callPackage ./volkovlabs-variable-panel { };
  yesoreyeram-infinity-datasource = callPackage ./yesoreyeram-infinity-datasource { };
}
