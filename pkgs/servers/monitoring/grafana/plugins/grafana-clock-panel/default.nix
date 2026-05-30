{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-clock-panel";
  version = "3.2.2";
  zipHash = "sha256-VjOg6qJXxhDAl8xYWD9ZZSNqSELMoREuyv+LX5xFOgM=";
  meta = {
    description = "Clock panel for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = lib.platforms.unix;
  };
}
