{ callPackage }:
{
  inherit callPackage;

  grafanaPlugin = callPackage ./grafana-plugin.nix { };

  grafana-clock-panel = callPackage ./grafana-clock-panel { };
}
