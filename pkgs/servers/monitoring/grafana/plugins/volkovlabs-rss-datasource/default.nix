{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "volkovlabs-rss-datasource";
  version = "4.2.0";
  zipHash = "sha256-+3tgvpH6xlJORqN4Sx7qwzsiQZoLwdarzhx6kHvtOoY=";
  meta = with lib; {
    description = "The RSS/Atom data source is a plugin for Grafana that retrieves RSS/Atom feeds and allows visualizing them using Dynamic Text and other panels.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
