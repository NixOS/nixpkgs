{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "marcusolsson-dynamictext-panel";
  version = "5.4.0";
  zipHash = "sha256-IgPON60oRqO52W64UvHuwYoa6UG2NfDWIA4S2HfkGQs=";
  meta = {
    description = "Dynamic, data-driven text panel for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ herbetom ];
    platforms = lib.platforms.unix;
  };
}
