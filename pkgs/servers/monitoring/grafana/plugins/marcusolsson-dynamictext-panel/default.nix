{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "marcusolsson-dynamictext-panel";
  version = "5.4.0";
  zipHash = "sha256-IgPON60oRqO52W64UvHuwYoa6UG2NfDWIA4S2HfkGQs=";
  meta = with lib; {
    description = "Dynamic, data-driven text panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ herbetom ];
    platforms = platforms.unix;
  };
}
