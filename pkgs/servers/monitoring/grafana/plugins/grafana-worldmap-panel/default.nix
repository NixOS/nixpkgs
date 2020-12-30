{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-worldmap-panel";
  version = "0.3.2";
  zipHash = "sha256-MGAJzS9X91x6wt305jH1chLoW3zd7pIYDwRnPg9qrgE=";
  meta = with lib; {
    description = "World Map panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
