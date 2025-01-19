{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-discourse-datasource";
  version = "2.0.2";
  zipHash = "sha256-0MTxPe7RJHMA0SwjOcFlbi4VkhlLUFP+5r2DsHAaffc=";
  meta = {
    description = "The Discourse data source plugin allows users to search and view topics, posts, users, tags, categories, and reports on a given Discourse forum.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
