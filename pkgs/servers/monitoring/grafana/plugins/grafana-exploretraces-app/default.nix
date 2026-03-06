{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "1.3.2";
  zipHash = "sha256-JXDZ7rC5Y38qJVmiEq2oz1DoWGIh9VX0bCZxdwlbDMo=";
  meta = {
    description = "Opinionated traces app";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
