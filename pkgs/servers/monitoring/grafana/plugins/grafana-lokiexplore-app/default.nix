{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-lokiexplore-app";
  version = "2.1.3";
  zipHash = "sha256-P16yiN9iSch74A8Yo/EQW/E1OWzB69jRFxQBe0t5E3Y=";
  meta = {
    description = "Browse Loki logs without the need for writing complex queries";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
