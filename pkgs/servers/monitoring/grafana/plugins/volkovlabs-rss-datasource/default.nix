{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-rss-datasource";
  version = "4.4.1";
  zipHash = "sha256-SaSzrtAiB97IM2se1RLBkkpZeFjMmvS9o5Si2aGOv+c=";
  meta = {
    description = "Plugin for Grafana that retrieves RSS/Atom feeds and allows visualizing them using Dynamic Text and other panels";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
