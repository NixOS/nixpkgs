{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "volkovlabs-rss-datasource";
  version = "3.0.1";
  zipHash = "sha256-RCs4ZAokI/U5I9+ALEb/+XeUL4dBQxNHR6Z7o5w2iDs=";
  meta = with lib; {
    description = "The RSS/Atom data source is a plugin for Grafana that retrieves RSS/Atom feeds and allows visualizing them using Dynamic Text and other panels.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
