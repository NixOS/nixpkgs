{ callPackage }:
{
  inherit callPackage;

  grafanaPlugin = callPackage ./grafana-plugin.nix { };

  grafana-clock-panel = callPackage ./grafana-clock-panel { };
  grafana-piechart-panel = callPackage ./grafana-piechart-panel { };
  grafana-polystat-panel = callPackage ./grafana-polystat-panel { };
  grafana-worldmap-panel = callPackage ./grafana-worldmap-panel { };
}
