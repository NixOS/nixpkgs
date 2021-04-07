{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-piechart-panel";
  version = "1.6.1";
  zipHash = "sha256-64K/efoBKuBFp8Jw79hTdMyTurTZsL0qfgPDcUWz2jg=";
  meta = with lib; {
    description = "Pie chart panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
