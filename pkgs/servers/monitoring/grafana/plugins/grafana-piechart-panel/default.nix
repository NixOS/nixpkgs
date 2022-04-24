{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-piechart-panel";
  version = "1.6.2";
  zipHash = "sha256-xKyVT092Ffgzl0BewQw5iZ14I/q6CviUR5t9BVM0bf0=";
  meta = with lib; {
    description = "Pie chart panel for Grafana";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
