{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clock-panel";
  version = "1.1.1";
  zipHash = "sha256-SvZyg7r+XG6i7jqYwxpPn6ZzJc7qmtfPtyphYppURDk=";
  meta = with lib; {
    description = "Clock panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
