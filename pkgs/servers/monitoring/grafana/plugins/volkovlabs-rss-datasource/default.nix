{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-rss-datasource";
  version = "4.3.0";
  zipHash = "sha256-HF37azbhlYp8RndUMr7Xs1ajgOTJplVP7rQzGQ0GrU4=";
  meta = with lib; {
    description = "Plugin for Grafana that retrieves RSS/Atom feeds and allows visualizing them using Dynamic Text and other panels";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
