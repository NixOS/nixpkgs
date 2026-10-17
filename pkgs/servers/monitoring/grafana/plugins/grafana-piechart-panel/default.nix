{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-piechart-panel";
  version = "1.6.4";
  zipHash = "sha256-bdAl3OmZgSNB+IxxlCb81abR+4dykKkRY3MpQUQyLks=";
  meta = {
    description = "Pie chart panel for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = lib.platforms.unix;
  };
}
