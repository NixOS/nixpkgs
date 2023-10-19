{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-piechart-panel";
  version = "1.6.4";
  zipHash = "sha256-bdAl3OmZgSNB+IxxlCb81abR+4dykKkRY3MpQUQyLks=";
  meta = with lib; {
    description = "Pie chart panel for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
