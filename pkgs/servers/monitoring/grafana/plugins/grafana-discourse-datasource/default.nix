{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-discourse-datasource";
  version = "2.0.2";
  zipHash = "sha256-0MTxPe7RJHMA0SwjOcFlbi4VkhlLUFP+5r2DsHAaffc=";
  meta = with lib; {
    description = "Allows users to search and view topics, posts, users, tags, categories, and reports on a given Discourse forum through Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
